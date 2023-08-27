import Foundation
import Combine

public struct StandardCombineNetworkController {
	private let logger: Logger

	let urlRequestConfiguration: URLRequestConfiguration
	let urlSessionBuilder: URLSessionBuilder
	let urlRequestBuilder: URLRequestBuilder
	let urlRequestsInterception: URLRequestInterception

	public init (
		configuration: URLRequestConfiguration,
		urlSessionBuilder: URLSessionBuilder = .standard(),
		urlRequestBuilder: URLRequestBuilder = .standard,
		interception: @escaping URLRequestInterception = { $0 }
	) {
		self.urlRequestConfiguration = configuration
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
		self.urlRequestsInterception = interception

		self.logger = .init()
	}

	private init (
		configuration: URLRequestConfiguration,
		urlSessionBuilder: URLSessionBuilder = .standard(),
		urlRequestBuilder: URLRequestBuilder = .standard,
		interception: @escaping URLRequestInterception = { $0 },
		logger: Logger
	) {
		self.urlRequestConfiguration = configuration
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
		self.urlRequestsInterception = interception
		self.logger = logger
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
				for interceptor in interceptors {
					buildUrlRequest = try await interceptor(buildUrlRequest)
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
	func withConfiguration (_ update: (URLRequestConfiguration) -> URLRequestConfiguration) -> Self {
		.init(
			configuration: update(urlRequestConfiguration),
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: urlRequestBuilder,
			interception: urlRequestsInterception,
			logger: logger
		)
	}
}

public extension StandardCombineNetworkController {
	@discardableResult
	func logging (_ logging: (Logger) -> Void) -> Self {
		logging(logger)
		return self
	}
}
