import Foundation
import Combine

public class StandardCombineNetworkController {
	private let logger = Logger()

	private let urlSessionBuilder: URLSessionBuilder
	private let urlRequestBuilder: URLRequestBuilder
	private let urlRequestsInterceptors: [URLRequestInterceptor]

	public init (
		urlSessionBuilder: URLSessionBuilder = .standard(),
		urlRequestBuilder: URLRequestBuilder,
		urlRequestsInterceptors: [URLRequestInterceptor] = []
	) {
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
		self.urlRequestsInterceptors = urlRequestsInterceptors
	}
}

extension StandardCombineNetworkController: CombineNetworkController {
	public func send <RQ: Request> (
		_ request: RQ,
		interceptors: URLRequestInterceptor? = nil
	) -> AnyPublisher<StandardResponse, ControllerError> {
		send(request, StandardResponse.self, interceptor: interceptors)
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interceptors: URLRequestInterceptor? = nil
	) -> AnyPublisher<RS, ControllerError> {
		send(request, RS.self, interceptor: interceptors)
	}

	public func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptors: URLRequestInterceptor? = nil
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError> {
		send(request, StandardModelResponse<RSM>.self, interceptor: interceptors)
	}
}

private extension StandardCombineNetworkController {
	func send <RQ: Request, RS: Response> (_ request: RQ, _ response: RS.Type, interceptor: URLRequestInterceptor?) -> AnyPublisher<RS, ControllerError> {
		let requestId = UUID()

		return Just(request)
			.tryMap { request in
				let urlSession = try urlSessionBuilder.build(request)
				let urlRequest = try urlRequestBuilder.build(request)

				logger.log(message: .request(urlSession, urlRequest), requestId: requestId, request: request)

				return (urlSession, urlRequest)
			}
			.tryMap { urlSession, urlRequest in
				let interceptors = (interceptor.map { [$0] } ?? []) + urlRequestsInterceptors
				let interceptedUrlRequest = try Chain.create(chainUnits: interceptors)?.transform(urlRequest)

				return (urlSession, interceptedUrlRequest ?? urlRequest)
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

public extension StandardCombineNetworkController {
	convenience init (
		urlSessionBuilder: URLSessionBuilder = .standard(),
		scheme: @escaping @autoclosure () -> String = "http",
		basePath: @escaping @autoclosure () -> String,
		query: @escaping @autoclosure () -> [String: String] = [:],
		headers: @escaping @autoclosure () -> [String: String] = [:],
		urlRequestsInterceptors: [URLRequestInterceptor] = []
	) {
		self.init(
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: .standard(
				scheme: scheme,
				basePath: basePath,
				query: query,
				headers: headers
			),
			urlRequestsInterceptors: urlRequestsInterceptors
		)
	}
}
