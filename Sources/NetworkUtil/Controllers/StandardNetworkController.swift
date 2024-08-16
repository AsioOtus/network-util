import Combine
import Foundation

public struct StandardNetworkController: NetworkController {
	let logger: Logger

	public let configuration: RequestConfiguration
	public let delegate: NetworkControllerDelegate

	public var logPublisher: LogPublisher {
		logger.eraseToAnyPublisher()
	}

	public var logs: AsyncStream<LogRecord> {
		logger.logs
	}

	public init (
		configuration: RequestConfiguration = .empty,
		delegate: NetworkControllerDelegate = .standard()
	) {
		self.configuration = configuration
		self.delegate = delegate

		self.logger = .init()
	}

	private init (
		configuration: RequestConfiguration,
		delegate: NetworkControllerDelegate,
		logger: Logger
	) {
		self.configuration = configuration
		self.delegate = delegate

		self.logger = logger
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

	var urlResponsesInterceptions: [URLResponseInterception] {
		delegate.urlResponsesInterceptions
	}

	var sending: AnySending? {
		delegate.sending
	}

	func controllerError (_ error: ControllerError, _ requestId: UUID, _ request: some Request) -> ControllerError {
		logger.log(message: .error(error), requestId: requestId, request: request)
		return error
	}
}

extension StandardNetworkController {
	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
		let requestId = UUID()

		let configuration = createConfiguration(
			request,
			configurationUpdate
		)

		let (urlSession, urlRequest) = try await createUrlEntities(
			requestId,
			request,
			delegate.encoding,
			configuration,
			delegate.urlRequestInterceptions
		)

		let (data, urlResponse) = try await sendAction(
			urlSession,
			urlRequest,
			requestId,
			request,
			configuration,
			delegate.urlSessionTaskDelegate,
			delegate.sending
		)

		let response: RS = try createResponse(
			data,
			urlResponse,
			requestId,
			request,
			delegate.decoding,
			delegate.urlResponseInterceptions
		)

		return response
	}
}

private extension StandardNetworkController {
	func createConfiguration <RQ: Request> (
		_ request: RQ,
		_ configurationUpdate: RequestConfiguration.Update?
	) -> RequestConfiguration {
		request
			.merge(with: configuration)
			.update(configurationUpdate ?? { $0 })
	}

	func createUrlEntities <RQ: Request> (
		_ requestId: UUID,
		_ request: RQ,
		_ encoding: ((RQ.Body) throws -> Data)?,
		_ configuration: RequestConfiguration,
		_ urlRequestsInterceptions: [URLRequestInterception]
	) async throws -> (URLSession, URLRequest) {
		do {
			let urlSession = try createUrlSession(request)

			let urlRequest = try await createUrlRequest(
				request,
				encoding,
				configuration,
				urlRequestsInterceptions
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

	func createUrlSession <RQ: Request> (
		_ request: RQ
	) throws -> URLSession {
		try urlSessionBuilder.build(request)
	}

	func createUrlRequest <RQ: Request> (
		_ request: RQ,
		_ encoding: ((RQ.Body) throws -> Data)?,
		_ configuration: RequestConfiguration,
		_ urlRequestInterceptions: [URLRequestInterception]
	) async throws -> URLRequest {
		let body = try encodeRequestBody(request, encoding)

		let urlRequest = try urlRequestBuilder.build(request.address, configuration, body)
		let interceptedUrlRequest = try await interceptUrlRequest(
			urlRequest,
			request.delegate.urlRequestInterception,
			urlRequestInterceptions
		)

		return interceptedUrlRequest
	}

	func interceptUrlRequest (
		_ urlRequest: URLRequest,
		_ urlRequestInterception: URLRequestInterception?,
		_ urlRequestInterceptions: [URLRequestInterception]
	) async throws -> URLRequest {
		var interceptedUrlRequest = urlRequest

		let interceptors = urlRequestsInterceptions + [urlRequestInterception].compactMap { $0 } + urlRequestInterceptions
		for interceptor in interceptors {
			interceptedUrlRequest = try await interceptor(interceptedUrlRequest)
		}

		return interceptedUrlRequest
	}

	func encodeRequestBody <RQ: Request> (
		_ request: RQ,
		_ encoding: ((RQ.Body) throws -> Data)?
	) throws -> Data? {
		guard let body = request.body else { return nil }

		if let data = body as? Data {
			return data
		} else if let encoding {
			return try encoding(body)
		} else if let encoding = request.delegate.encoding {
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
		_ configuration: RequestConfiguration,
		_ urlSessionTaskDelegate: URLSessionTaskDelegate?,
		_ sending: Sending<RQ>?
	) async throws -> (Data, URLResponse) {
		let urlSessionTaskDelegate = urlSessionTaskDelegate ?? request.delegate.urlSessionTaskDelegate

		let anySendingModel = AnySendingModel(
			urlSession: urlSession,
			urlRequest: urlRequest,
			requestId: requestId,
			request: request,
			configuration: configuration
		)

		let controllerSending = self.sending ?? emptyAnySending()

		return try await controllerSending(anySendingModel) { urlSession, urlRequest in
			let sendingModel = SendingModel(
				urlSession: urlSession,
				urlRequest: urlRequest,
				requestId: requestId,
				request: request,
				configuration: configuration
			)

			let sending = sending ?? emptySending()

			return try await sending(sendingModel) { urlSession, urlRequest in
				try await self.send(
					urlSession,
					urlRequest,
					requestId,
					request,
					urlSessionTaskDelegate
				)
			}
		}
	}

	func send <RQ: Request> (
		_ urlSession: URLSession,
		_ urlRequest: URLRequest,
		_ requestId: UUID,
		_ request: RQ,
		_ urlSessionTaskDelegate: URLSessionTaskDelegate?
	) async throws -> (Data, URLResponse) {
		do {
			let (data, urlResponse) = try await urlSession.data(for: urlRequest, delegate: urlSessionTaskDelegate)
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
				.init(requestId: requestId, request: request, category: .general(error)),
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
		_ decoding: ((Data) throws -> RS.Model)?,
		_ urlResponseInterceptions: [URLResponseInterception]
	) throws -> RS {
		do {
			let (interceptedData, interceptedUrlResponse) = try interceptUrlResponse(data, urlResponse, urlResponseInterceptions)
			let model = try decodeResponseData(interceptedData, decoding)
			let response = try RS(interceptedData, interceptedUrlResponse, model)
			return response
		} catch {
			throw controllerError(
				.init(requestId: requestId, request: request, category: .response(error)),
				requestId,
				request
			)
		}
	}

	func interceptUrlResponse (
		_ data: Data,
		_ urlResponse: URLResponse,
		_ urlResponseInterceptions: [URLResponseInterception]
	) throws -> (Data, URLResponse) {
		var interceptedData = data
		var interceptedUrlResponse = urlResponse

		let interceptors = urlResponsesInterceptions + urlResponseInterceptions
		for interceptor in interceptors {
			(interceptedData, interceptedUrlResponse) = try interceptor(interceptedData, interceptedUrlResponse)
		}

		return (data, urlResponse)
	}

	func decodeResponseData <RSM: Decodable> (
		_ data: Data,
		_ decoding: ((Data) throws -> RSM)?
	) throws -> RSM {
		if let data = data as? RSM {
			return data
		} else if let decoding {
			return try decoding(data)
		} else {
			return try decoder.decode(RSM.self, from: data)
		}
	}
}

public extension StandardNetworkController {
	func configuration (_ update: RequestConfiguration.Update) -> NetworkController {
		Self(
			configuration: update(configuration),
			delegate: delegate,
			logger: logger
		)
	}

	func replace (configuration: RequestConfiguration) -> NetworkController {
		Self(
			configuration: configuration,
			delegate: delegate,
			logger: logger
		)
	}
}

public extension NetworkController where Self == StandardNetworkController {
	static func standard (
		configuration: RequestConfiguration,
		delegate: NetworkControllerDelegate = .standard()
	) -> Self {
		.init(
			configuration: configuration,
			delegate: delegate
		)
	}
}
