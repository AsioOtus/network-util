import Foundation

public struct StandardAsyncNetworkController {
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

extension StandardAsyncNetworkController: FullScaleAsyncNetworkController {
	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
    response: RS.Type,
    configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> RS {
		let requestId = UUID()

		let urlSession: URLSession
		let urlRequest: URLRequest
		do {
			urlSession = try await urlSessionBuilder.build(request)

      let updatedConfiguration = configurationUpdate(urlRequestConfiguration)
			var buildUrlRequest = try await urlRequestBuilder.build(request, updatedConfiguration)

			let interceptors = [urlRequestsInterception, request.interception, interception]
			for interceptor in interceptors {
				buildUrlRequest = try await interceptor(buildUrlRequest)
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

  public func withConfiguration (update: (URLRequestConfiguration) -> URLRequestConfiguration) -> ConfigurableAsyncNetworkController {
    Self(
      configuration: update(urlRequestConfiguration),
      urlSessionBuilder: urlSessionBuilder,
      urlRequestBuilder: urlRequestBuilder,
      interception: urlRequestsInterception,
      logger: logger
    )
  }

  @discardableResult
  public func logging (_ logging: (Logger) -> Void) -> Self {
    logging(logger)
    return self
  }
}

extension StandardAsyncNetworkController {
  func controllerError (_ error: ControllerError, _ requestId: UUID, _ request: Request) -> ControllerError {
    logger.log(message: .error(error), requestId: requestId, request: request)
    return error
  }
}
