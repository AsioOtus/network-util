import Combine
import Foundation

public struct StandardURLClient: URLClient {
	let logger: Logger

	public let configuration: RequestConfiguration
	public let delegate: URLClientDelegate

	public var logPublisher: AnyPublisher<LogRecord, Never> {
		logger.eraseToAnyPublisher()
	}

	public init (
		configuration: RequestConfiguration = .empty,
		delegate: URLClientDelegate = .standard()
	) {
		self.configuration = configuration
		self.delegate = delegate

		self.logger = .init()
	}

	private init (
		configuration: RequestConfiguration,
		delegate: URLClientDelegate,
		logger: Logger
	) {
		self.configuration = configuration
		self.delegate = delegate

		self.logger = logger
	}
}

public extension StandardURLClient {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some URLClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
        let requestId = delegate.id?() ?? .init()

        var urlRequestBuffer: URLRequest?
        var dataBuffer: Data?
        var urlResponseBuffer: URLResponse?

        do {
            let (urlSession, urlRequest, configuration) = try await requestEntities(
                request,
                response: response,
                delegate: delegate,
                configurationUpdate: configurationUpdate
            )

            urlRequestBuffer = urlRequest

            logger.log(
                message: .request(urlSession, urlRequest),
                requestId: requestId,
                request: request,
                completion: nil
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

            dataBuffer = data
            urlResponseBuffer = urlResponse

            logger.log(
                message: .response(data, urlResponse),
                requestId: requestId,
                request: request,
                completion: .init(
                    urlRequest: urlRequest,
                    data: data,
                    urlResponse: urlResponse,
                    error: nil
                )
            )

            let response: RS = try createResponse(
                data,
                urlResponse,
                delegate.decoding,
                delegate.urlResponseInterceptions
            )

            return response
        } catch let errorCategory as URLClientError.Category {
            let error = URLClientError(requestId: requestId, request: request, category: errorCategory)
            logger.log(
                message: .error(error),
                requestId: requestId,
                request: request,
                completion: .init(
                    urlRequest: urlRequestBuffer,
                    data: dataBuffer,
                    urlResponse: urlResponseBuffer,
                    error: error
                )
            )
            throw error
        } catch let error {
            let error = URLClientError(requestId: requestId, request: request, category: .general(error) )
            logger.log(
                message: .error(error),
                requestId: requestId,
                request: request,
                completion: .init(
                    urlRequest: urlRequestBuffer,
                    data: dataBuffer,
                    urlResponse: urlResponseBuffer,
                    error: error
                )
            )
            throw error
        }
	}
}

private extension StandardURLClient {
	func createConfiguration <RQ: Request> (
		_ request: RQ,
		_ configurationUpdate: RequestConfiguration.Update?
	) -> RequestConfiguration {
		let configuration = request.mergeConfiguration(with: configuration)
        return configurationUpdate?(configuration) ?? configuration
	}

	func createUrlEntities <RQ: Request> (
		_ request: RQ,
		_ encoding: ((RQ.Body) throws -> Data)?,
		_ configuration: RequestConfiguration,
		_ urlRequestsInterceptions: [URLRequestInterception]
	) async throws -> (URLSession, URLRequest) {
		do {
			let urlSession = try createUrlSession(configuration)

			let urlRequest = try await createUrlRequest(
				request,
				encoding,
				configuration,
				urlRequestsInterceptions
			)

			return (urlSession, urlRequest)
		} catch {
            throw URLClientError.Category.request(error)
		}
	}

	func createUrlSession (
		_ configuration: RequestConfiguration
	) throws -> URLSession {
		try urlSessionBuilder.build(configuration: configuration)
	}

	func createUrlRequest <RQ: Request> (
		_ request: RQ,
		_ encoding: ((RQ.Body) throws -> Data)?,
		_ configuration: RequestConfiguration,
		_ urlRequestInterceptions: [URLRequestInterception]
	) async throws -> URLRequest {
		let body = try encodeRequestBody(request, encoding)

		let urlRequest = try urlRequestBuilder.build(
			address: request.address,
			configuration: configuration,
			body: body
		)
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

		let clientSending = self.sending ?? emptyAnySending()

		return try await clientSending(anySendingModel) { urlSession, urlRequest in
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
					urlSessionTaskDelegate
				)
			}
		}
	}

	func send (
		_ urlSession: URLSession,
		_ urlRequest: URLRequest,
		_ urlSessionTaskDelegate: URLSessionTaskDelegate?
	) async throws -> (Data, URLResponse) {
		do {
			let (data, urlResponse) = if #available(iOS 15.0, *) {
				try await urlSession.data(for: urlRequest, delegate: urlSessionTaskDelegate)
			} else {
				try await urlSession.data(for: urlRequest)
			}

			return (data, urlResponse)
		} catch let urlError as URLError {
            throw URLClientError.Category.network(.init(urlSession, urlRequest, urlError))
		}
	}

	func createResponse <RS: Response> (
		_ data: Data,
		_ urlResponse: URLResponse,
		_ decoding: Decoding<RS.Model>?,
		_ urlResponseInterceptions: [URLResponseInterception]
	) throws -> RS {
		do {
			let (interceptedData, interceptedUrlResponse) = try interceptUrlResponse(data, urlResponse, urlResponseInterceptions)
			let model = try decodeResponseData(interceptedData, decoding, interceptedUrlResponse)
            let response = RS(data: interceptedData, urlResponse: interceptedUrlResponse, model: model)
			return response
		} catch {
            throw URLClientError.Category.response(error)
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
		_ decoding: Decoding<RSM>?,
		_ urlResponse: URLResponse
	) throws -> RSM {
		if let data = data as? RSM {
			return data
		} else if let decoding {
			return try decoding(
				data,
				urlResponse,
				decoder
			)
		} else {
			return try decoder.decode(
				RSM.self,
				from: data,
				urlResponse: urlResponse
			)
		}
	}
}

public extension StandardURLClient {
	func configuration (_ update: RequestConfiguration.Update) -> URLClient {
		Self(
			configuration: update(configuration),
			delegate: delegate,
			logger: logger
		)
	}

	func setConfiguration (_ configuration: RequestConfiguration) -> URLClient {
		Self(
			configuration: configuration,
			delegate: delegate,
			logger: logger
		)
	}

	func delegate (_ delegate: URLClientDelegate) -> URLClient {
		Self(
			configuration: configuration,
			delegate: delegate,
			logger: logger
		)
	}
}

public extension StandardURLClient {
    static let defaultUrlSessionBuilder: URLSessionBuilder = .standard()
    static let defaultUrlRequestBuilder: URLRequestBuilder = .standard()
    static let defaultEncoder: RequestBodyEncoder = JSONEncoder()
    static let defaultDecoder: ResponseModelDecoder = JSONDecoder()

    func requestEntities <RQ: Request, RS: Response> (
        _ request: RQ,
        response: RS.Type,
        delegate: some URLClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> (urlSession: URLSession, urlRequest: URLRequest, configuration: RequestConfiguration) {
        let configuration = createConfiguration(
            request,
            configurationUpdate
        )

        let (urlSession, urlRequest) = try await createUrlEntities(
            request,
            delegate.encoding,
            configuration,
            delegate.urlRequestInterceptions
        )

        return (urlSession, urlRequest, configuration)
    }
}

private extension StandardURLClient {
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
}

public extension URLClient where Self == StandardURLClient {
	static func standard (
        configuration: RequestConfiguration = .empty,
		delegate: URLClientDelegate = .standard()
	) -> Self {
		.init(
			configuration: configuration,
			delegate: delegate
		)
	}
}
