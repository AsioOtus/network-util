import Foundation
import Combine

public struct StandardCombineNetworkController {
	private let logger = Logger()

	private let urlRequestConfiguration: URLRequestConfiguration
	private let urlSessionBuilder: URLSessionBuilder
	private let urlRequestBuilder: URLRequestBuilder
	private let urlRequestsInterception: URLRequestInterception

	public init (
		urlRequestConfiguration: URLRequestConfiguration,
		urlSessionBuilder: URLSessionBuilder = .standard(),
		urlRequestBuilder: URLRequestBuilder,
		urlRequestsInterception: @escaping URLRequestInterception = { $0 }
	) {
		self.urlRequestConfiguration = urlRequestConfiguration
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
		self.urlRequestsInterception = urlRequestsInterception
	}
}

extension StandardCombineNetworkController: CombineNetworkController {
	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interception: @escaping URLRequestInterception = { $0 }
	) -> AnyPublisher<RS, ControllerError> {
		let requestId = UUID()

		return Just(request)
      .asyncTryMap { request in
        let urlSession = try await self.urlSessionBuilder.build(request)
				var urlRequest = try await self.urlRequestBuilder.build(request, self.urlRequestConfiguration)

        self.logger.log(message: .request(urlSession, urlRequest), requestId: requestId, request: request)

				let interceptors = [urlRequestsInterception, request.interception, interception]
				for i in interceptors {
					urlRequest = try await i(urlRequest)
				}

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
