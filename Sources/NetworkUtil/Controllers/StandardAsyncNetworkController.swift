import Foundation

public struct StandardAsyncNetworkController {
	private let logger = Logger()

	private let urlRequestConfiguration: URLRequestConfiguration
	private let urlSessionBuilder: URLSessionBuilder
	private let urlRequestBuilder: URLRequestBuilder
	private let urlRequestsInterception: URLRequestInterception

  public init (
		urlRequestConfiguration: URLRequestConfiguration,
    urlSessionBuilder: URLSessionBuilder = .standard(),
    urlRequestBuilder: URLRequestBuilder = .standard,
		urlRequestsInterception: @escaping URLRequestInterception = { $0 }
  ) {
		self.urlRequestConfiguration = urlRequestConfiguration
    self.urlSessionBuilder = urlSessionBuilder
    self.urlRequestBuilder = urlRequestBuilder
    self.urlRequestsInterception = urlRequestsInterception
  }
}

extension StandardAsyncNetworkController: AsyncNetworkController {
	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
    response: RS.Type,
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> RS {
		let requestId = UUID()

		let urlSession: URLSession
		let urlRequest: URLRequest
		do {
			urlSession = try await urlSessionBuilder.build(request)

			var buildUrlRequest = try await urlRequestBuilder.build(request, urlRequestConfiguration)

			let interceptors = [urlRequestsInterception, request.interception, interception]
			for i in interceptors {
				buildUrlRequest = try await i(buildUrlRequest)
			}

			urlRequest = buildUrlRequest

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
