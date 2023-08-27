import Foundation

public struct StandardAsyncNetworkController {
	private let logger = Logger()

	private let urlRequestConfiguration: URLRequestConfiguration
	private let urlSessionBuilder: URLSessionBuilder
	private let urlRequestBuilder: URLRequestBuilder
	private let urlRequestsInterceptors: [any URLRequestInterceptor]

	public init (
		urlRequestConfiguration: URLRequestConfiguration,
		urlSessionBuilder: URLSessionBuilder = .standard(),
		urlRequestBuilder: URLRequestBuilder = .standard,
		interceptors: [any URLRequestInterceptor] = []
	) {
		self.urlRequestConfiguration = urlRequestConfiguration
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
		self.urlRequestsInterceptors = interceptors
	}

  public init (
		urlRequestConfiguration: URLRequestConfiguration,
    urlSessionBuilder: URLSessionBuilder = .standard(),
    urlRequestBuilder: URLRequestBuilder = .standard,
    interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
  ) {
		self.urlRequestConfiguration = urlRequestConfiguration
    self.urlSessionBuilder = urlSessionBuilder
    self.urlRequestBuilder = urlRequestBuilder
    self.urlRequestsInterceptors = [.compact(interception)]
  }
}

extension StandardAsyncNetworkController: AsyncNetworkController {
	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
    response: RS.Type,
    interceptor: some URLRequestInterceptor = .empty()
	) async throws -> RS {
		let requestId = UUID()

		let urlSession: URLSession
		let urlRequest: URLRequest
		do {
			urlSession = try await urlSessionBuilder.build(request)

			let buildUrlRequest = try await urlRequestBuilder.build(request, urlRequestConfiguration)
			let interceptors = [interceptor] + [.compact(request.interception)] + urlRequestsInterceptors
			let interceptedUrlRequest = try await URLRequestInterceptorChain.create(chainUnits: interceptors)?.transform(buildUrlRequest)

			urlRequest = interceptedUrlRequest ?? buildUrlRequest

			logger.log(message: .request(urlSession, urlRequest), requestId: requestId, request: request)
		} catch {
			throw controllerError(
				.init(requestId: requestId, request: request, category: .request(error)),
				requestId,
				request
			)
		}

		let data: Data
		let urlResponse: URLResponse
		do {
			(data, urlResponse) = try await urlSession.data(for: urlRequest)
			logger.log(message: .response(data, urlResponse), requestId: requestId, request: request)
		} catch let urlError as URLError {
			throw controllerError(
				.init(requestId: requestId, request: request, category: .network(.init(urlSession, urlRequest, urlError))),
				requestId,
				request
			)
		} catch {
			throw controllerError(
				.init(requestId: requestId, request: request, category: .general(.other(error))),
				requestId,
				request
			)
		}

		let response: RS
		do {
			response = try .init(data, urlResponse)
		} catch {
			throw controllerError(
				.init(requestId: requestId, request: request, category: .response(error)),
				requestId,
				request
			)
		}

		return response
	}

	func controllerError (_ error: ControllerError, _ requestId: UUID, _ request: Request) -> ControllerError {
		logger.log(message: .error(error), requestId: requestId, request: request)
		return error
	}
}

public extension StandardAsyncNetworkController {
	@discardableResult
	func logging (_ logging: (Logger) -> Void) -> Self {
		logging(logger)
		return self
	}
}
