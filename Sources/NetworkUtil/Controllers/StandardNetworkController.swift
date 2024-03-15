import Combine
import Foundation

public struct StandardNetworkController {
	let logger: Logger

	public let urlRequestConfiguration: URLRequestConfiguration
	public let urlSessionBuilder: URLSessionBuilder
	public let urlRequestBuilder: URLRequestBuilder
	public let urlRequestsInterception: URLRequestInterception

  public var logPublisher: LogPublisher {
    logger.eraseToAnyPublisher()
  }

  public var logs: AsyncStream<LogRecord> {
    logger.logs
  }

  public init (
		configuration: URLRequestConfiguration,
    urlSessionBuilder: URLSessionBuilder = .standard(),
    urlRequestBuilder: URLRequestBuilder = .standard(),
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
		urlRequestBuilder: URLRequestBuilder = .standard(),
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

extension StandardNetworkController: FullScaleAsyncNetworkController {
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

  public func withConfiguration (update: (URLRequestConfiguration) -> URLRequestConfiguration) -> FullScaleAsyncNetworkController {
    Self(
      configuration: update(urlRequestConfiguration),
      urlSessionBuilder: urlSessionBuilder,
      urlRequestBuilder: urlRequestBuilder,
      interception: urlRequestsInterception,
      logger: logger
    )
  }

	public func replaceConfiguration (_ configuration: URLRequestConfiguration) -> FullScaleAsyncNetworkController {
		withConfiguration { _ in configuration }
	}

  public func addInterception (_ interception: @escaping URLRequestInterception) -> FullScaleAsyncNetworkController {
    Self(
      configuration: urlRequestConfiguration,
      urlSessionBuilder: urlSessionBuilder,
      urlRequestBuilder: urlRequestBuilder,
      interception: { urlRequest in
        let interceptedUrlRequest = try await interception(urlRequest)
        return try await urlRequestsInterception(interceptedUrlRequest)
      },
      logger: logger
    )
  }

  @discardableResult
  public func logging (_ logging: (LogPublisher) -> Void) -> FullScaleAsyncNetworkController {
    logging(logPublisher)
    return self
  }
}

extension StandardNetworkController {
  func controllerError (_ error: ControllerError, _ requestId: UUID, _ request: some Request) -> ControllerError {
    logger.log(message: .error(error), requestId: requestId, request: request)
    return error
  }
}
