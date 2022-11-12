import Foundation
import Combine

public class StandardCombineNetworkController {
	private let logger = Logger()

	private let urlSessionBuilder: URLSessionBuilder
	private let urlRequestBuilder: URLRequestBuilder

	public required init (
		urlSessionBuilder: URLSessionBuilder = .standard(),
		urlRequestBuilder: URLRequestBuilder
	) {
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
	}
}

extension StandardCombineNetworkController {
	public func send <RQ: Request> (_ request: RQ) -> AnyPublisher<StandardResponse, ControllerError> {
		send(request, StandardResponse.self)
	}

	public func send <RQ: Request, RS: Response> (_ request: RQ, response: RS.Type) -> AnyPublisher<RS, ControllerError> {
		send(request, RS.self)
	}

	public func send <RQ: Request, RSM: ResponseModel> (_ request: RQ, responseModel: RSM.Type) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError> {
		send(request, StandardModelResponse<RSM>.self)
	}
}

private extension StandardCombineNetworkController {
	func send <RQ: Request, RS: Response> (_ request: RQ, _ response: RS.Type) -> AnyPublisher<RS, ControllerError> {
		let requestId = UUID()

		return Just(request)
			.tryMap { request in
				let urlSession = try urlSessionBuilder.build(request)
				let urlRequest = try urlRequestBuilder.build(request)

				logger.log(message: .request(urlSession, urlRequest), requestId: requestId, request: request)

				return (urlSession, urlRequest)
			}
			.mapError { ControllerError(requestId: requestId, request: request, category: .request($0)) }
			.flatMap { urlSession, urlRequest in
				urlSession.dataTaskPublisher(for: urlRequest)
					.mapError {	ControllerError(requestId: requestId, request: request, category: .network(.init(urlSession, urlRequest, $0))) }
					.eraseToAnyPublisher()
			}
			.tryMap { data, urlResponse -> RS in
				self.logger.log(message: .response(data, urlResponse), requestId: requestId, request: request)

				let response = try RS(data, urlResponse)
				return response
			}
			.mapError { ControllerError(requestId: requestId, request: request, category: .response($0)) }
			.handleEvents(
				receiveCompletion: { completion in
					if case .failure(let error) = completion {
						self.logger.log(message: .error(error), requestId: requestId, request: request)
					}
				}
			)
			.eraseToAnyPublisher()
	}
}

public extension StandardCombineNetworkController {
	@discardableResult
	func logging (_ logging: (Logger) -> Void) -> Self {
		logging(logger)
		return self
	}
}

extension StandardCombineNetworkController: StandardBuilderInitializable { }
