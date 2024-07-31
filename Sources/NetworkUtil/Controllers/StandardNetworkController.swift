import Combine
import Foundation

public struct StandardNetworkController {
	let logger: Logger

	public let urlRequestConfiguration: URLRequestConfiguration
	public let delegate: NetworkControllerDelegate

	public var logPublisher: LogPublisher {
		logger.eraseToAnyPublisher()
	}

	public var logs: AsyncStream<LogRecord> {
		logger.logs
	}

	public init (
		configuration: URLRequestConfiguration,
		delegate: NetworkControllerDelegate = .delegate()
	) {
		self.urlRequestConfiguration = configuration
		self.delegate = delegate

		self.logger = .init()
	}

	private init (
		configuration: URLRequestConfiguration,
		delegate: NetworkControllerDelegate,
		logger: Logger
	) {
		self.urlRequestConfiguration = configuration
		self.delegate = delegate

		self.logger = logger
	}
}

extension StandardNetworkController: FullScaleNetworkController {
	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		responseType: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: URLRequestConfiguration.Update? = nil
	) async throws -> RS {
		let requestId = UUID()

		let (urlSession, urlRequest) = try await createUrlEntities(
			requestId,
			request,
			delegate.encoding,
			configurationUpdate,
			delegate.urlRequestInterception
		)

		let (data, urlResponse) = try await sendAction(
			urlSession,
			urlRequest,
			requestId,
			request,
			delegate.sending
		)

		let response: RS = try createResponse(
			data,
			urlResponse,
			requestId,
			request,
			delegate.decoding
		)

		return response
	}
}

private extension StandardNetworkController {
	func createUrlEntities <RQ: Request> (
		_ requestId: UUID,
		_ request: RQ,
		_ encoding: ((RQ.Body) throws -> Data)?,
		_ configurationUpdate: URLRequestConfiguration.Update?,
		_ interception: URLRequestInterception?
	) async throws -> (URLSession, URLRequest) {
		do {
			let urlSession = try createUrlSession(request)

			let urlRequest = try await createUrlRequest(
				request,
				encoding,
				configurationUpdate,
				interception
			)

			logger.log(message: .request(urlSession, urlRequest), requestId: requestId, request: request)

			return (urlSession, urlRequest)
		} catch {
			throw controllerError(
				.init(requestId: requestId, request: request, category: .request(error)),
				requestId,
				request
			)
		}
	}

	func createUrlSession <RQ: Request> (_ request: RQ) throws -> URLSession {
		try urlSessionBuilder.build(request)
	}

	func createUrlRequest <RQ: Request> (
		_ request: RQ,
		_ encoding: ((RQ.Body) throws -> Data)?,
		_ configurationUpdate: URLRequestConfiguration.Update?,
		_ interception: URLRequestInterception?
	) async throws -> URLRequest {
		let body = try encodeRequestBody(request, encoding)

		let requestUpdatedConfiguration = request.configurationUpdate(urlRequestConfiguration)
		let updatedConfiguration = configurationUpdate?(requestUpdatedConfiguration) ?? requestUpdatedConfiguration

		var buildUrlRequest = try urlRequestBuilder.build(request, body, updatedConfiguration)

		let interceptors = urlRequestsInterceptions + [request.interception, interception].compactMap { $0 }
		for interceptor in interceptors {
			buildUrlRequest = try await interceptor(buildUrlRequest)
		}

		return buildUrlRequest
	}

	func encodeRequestBody <RQ: Request> (
		_ request: RQ,
		_ encoding: ((RQ.Body) throws -> Data)?
	) throws -> Data? {
		guard let body = request.body else { return nil }

		if let encoding {
			return try encoding(body)
		} else {
			return try encoder.encode(body)
		}
	}

	func sendAction <RQ: Request> (
		_ urlSession: URLSession,
		_ urlRequest: URLRequest,
		_ requestId: UUID,
		_ request: RQ,
		_ sending: Sending<RQ>?
	) async throws -> (Data, URLResponse) {
		try await (self.sending ?? defaultSendingTypeErased())(urlSession, urlRequest, requestId, request) { urlSession, urlRequest, requestId in
			try await (sending ?? defaultSending())(urlSession, urlRequest, requestId, request) { urlSession, urlRequest, requestId, request in
				try await send(
					urlSession,
					urlRequest,
					requestId,
					request
				)
			}
		}
	}

	func send <RQ: Request> (
		_ urlSession: URLSession,
		_ urlRequest: URLRequest,
		_ requestId: UUID,
		_ request: RQ
	) async throws -> (Data, URLResponse) {
		do {
			let (data, urlResponse) = try await urlSession.data(for: urlRequest)
			logger.log(message: .response(data, urlResponse), requestId: requestId, request: request)

			return (data, urlResponse)
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
	}

	func createResponse <RQ: Request, RS: Response> (
		_ data: Data,
		_ urlResponse: URLResponse,
		_ requestId: UUID,
		_ request: RQ,
		_ decoding: ((Data) throws -> RS.Model)?
	) throws -> RS {
		do {
			let model = try decodeResponseData(data, decoding)
			let response = try RS(data, urlResponse, model)
			return response
		} catch {
			throw controllerError(
				.init(requestId: requestId, request: request, category: .response(error)),
				requestId,
				request
			)
		}
	}

	func decodeResponseData <RSM: Decodable> (
		_ data: Data,
		_ decoding: ((Data) throws -> RSM)?
	) throws -> RSM {
		if let decoding {
			return try decoding(data)
		} else {
			return try decoder.decode(RSM.self, from: data)
		}
	}
}

public extension StandardNetworkController {
	func withConfiguration (update: URLRequestConfiguration.Update) -> FullScaleNetworkController {
		Self(
			configuration: update(urlRequestConfiguration),
			delegate: delegate,
			logger: logger
		)
	}

	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> FullScaleNetworkController {
		withConfiguration { _ in configuration }
	}

	func withConfiguration(update: URLRequestConfiguration.Update) -> ConfigurableNetworkController {
		let nc: FullScaleNetworkController = withConfiguration(update: update)
		return nc as ConfigurableNetworkController
	}

	func replaceConfiguration(_ configuration: URLRequestConfiguration) -> ConfigurableNetworkController {
		let nc: FullScaleNetworkController = replaceConfiguration(configuration)
		return nc as ConfigurableNetworkController
	}

	func addUrlRequestInterception (_ interception: @escaping URLRequestInterception) -> FullScaleNetworkController {
		Self(
			configuration: urlRequestConfiguration,
			delegate: delegate.addUrlRequestInterception(interception),
			logger: logger
		)
	}

	func addUrlResponseInterception (_ interception: @escaping URLResponseInterception) -> FullScaleNetworkController {
		Self(
			configuration: urlRequestConfiguration,
			delegate: delegate.addUrlResponseInterception(interception),
			logger: logger
		)
	}
}

private extension StandardNetworkController {
	static let defaultUrlSessionBuilder: URLSessionBuilder = .standard()
	static let defaultUrlRequestBuilder: URLRequestBuilder = .standard()
	static let defaultEncoder: RequestBodyEncoder = JSONEncoder()
	static let defaultDecoder: ResponseModelDecoder = JSONDecoder()

	var urlSessionBuilder: URLSessionBuilder {
		delegate.urlSessionBuilder ?? Self.defaultUrlSessionBuilder
	}

	var urlRequestBuilder: URLRequestBuilder {
		delegate.urlRequestBuilder ?? Self.defaultUrlRequestBuilder
	}

	var encoder: RequestBodyEncoder {
		delegate.encoder ?? Self.defaultEncoder
	}

	var decoder: ResponseModelDecoder {
		delegate.decoder ?? Self.defaultDecoder
	}

	var urlRequestsInterceptions: [URLRequestInterception] {
		delegate.urlRequestsInterceptions
	}

	var sending: SendingTypeErased? {
		delegate.sending
	}

	func controllerError (_ error: ControllerError, _ requestId: UUID, _ request: some Request) -> ControllerError {
		logger.log(message: .error(error), requestId: requestId, request: request)
		return error
	}
}

public extension NetworkController where Self == StandardNetworkController {
	static func standard (
		configuration: URLRequestConfiguration,
		delegate: NetworkControllerDelegate = .delegate()
	) -> Self {
		.init(
			configuration: configuration,
			delegate: delegate
		)
	}
}
