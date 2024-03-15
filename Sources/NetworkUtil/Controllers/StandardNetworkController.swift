import Combine
import Foundation

public struct StandardNetworkController {
	let logger: Logger

	public let urlRequestConfiguration: URLRequestConfiguration
	public let urlSessionBuilder: URLSessionBuilder
	public let urlRequestBuilder: URLRequestBuilder
	public let encoder: RequestBodyEncoder
	public let decoder: ResponseModelDecoder
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
		encoder: RequestBodyEncoder = JSONEncoder(),
		decoder: ResponseModelDecoder = JSONDecoder(),
		interception: @escaping URLRequestInterception = { $0 }
	) {
		self.urlRequestConfiguration = configuration
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
		self.encoder = encoder
		self.decoder = decoder
		self.urlRequestsInterception = interception

		self.logger = .init()
	}

	private init (
		configuration: URLRequestConfiguration,
		urlSessionBuilder: URLSessionBuilder,
		urlRequestBuilder: URLRequestBuilder,
		encoder: RequestBodyEncoder,
		decoder: ResponseModelDecoder,
		interception: @escaping URLRequestInterception,
		logger: Logger
	) {
		self.urlRequestConfiguration = configuration
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
		self.encoder = encoder
		self.decoder = decoder
		self.urlRequestsInterception = interception

		self.logger = logger
	}
}

extension StandardNetworkController: FullScaleNetworkController {
	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		encoding: ((Encodable) throws -> Data)? = nil,
		decoding: ((Data) throws -> RS.Model)? = nil,
		configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> RS {
		let requestId = UUID()

		let (urlSession, urlRequest) = try await createUrlEntities(
			requestId,
			request,
			encoding,
			configurationUpdate,
			interception
		)

		let (data, urlResponse) = try await send(
			urlSession,
			urlRequest,
			requestId,
			request
		)

		let response: RS = try createResponse(
			data,
			urlResponse,
			requestId,
			request
		)

		return response
	}
}

private extension StandardNetworkController {
	func createUrlEntities <RQ: Request> (
		_ requestId: UUID,
		_ request: RQ,
		_ encoding: ((Encodable) throws -> Data)? = nil,
		_ configurationUpdate: URLRequestConfiguration.Update = { $0 },
		_ interception: @escaping URLRequestInterception = { $0 }
	) async throws -> (URLSession, URLRequest) {
		do {
			let urlSession = try urlSessionBuilder.build(request)

			let body = try encodeRequestBody(request, encoding)
			let updatedConfiguration = configurationUpdate(urlRequestConfiguration)
			var buildUrlRequest = try urlRequestBuilder.build(request, body, updatedConfiguration)

			let interceptors = [urlRequestsInterception, request.interception, interception]
			for interceptor in interceptors {
				buildUrlRequest = try await interceptor(buildUrlRequest)
			}

			let urlRequest = buildUrlRequest

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

	func encodeRequestBody <RQ: Request> (
		_ request: RQ,
		_ encoding: ((Encodable) throws -> Data)?
	) throws -> Data {
		if let encoding {
			return try encoding(request.body)
		} else {
			return try encoder.encode(request.body)
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
		_ decoding: ((Data) throws -> RS.Model)? = nil
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
		_ decoding: ((Data) throws -> RSM)? = nil
	) throws -> RSM {
		if let decoding {
			return try decoding(data)
		} else {
			return try decoder.decode(RSM.self, from: data)
		}
	}
}

public extension StandardNetworkController {
	func withConfiguration (update: (URLRequestConfiguration) -> URLRequestConfiguration) -> FullScaleNetworkController {
		Self(
			configuration: update(urlRequestConfiguration),
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: urlRequestBuilder,
			encoder: encoder,
			decoder: decoder,
			interception: urlRequestsInterception,
			logger: logger
		)
	}

	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> FullScaleNetworkController {
		withConfiguration { _ in configuration }
	}

	func addInterception (_ interception: @escaping URLRequestInterception) -> FullScaleNetworkController {
		Self(
			configuration: urlRequestConfiguration,
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: urlRequestBuilder,
			encoder: encoder,
			decoder: decoder,
			interception: { urlRequest in
				let interceptedUrlRequest = try await interception(urlRequest)
				return try await urlRequestsInterception(interceptedUrlRequest)
			},
			logger: logger
		)
	}

	@discardableResult
	func logging (_ logging: (LogPublisher) -> Void) -> FullScaleNetworkController {
		logging(logPublisher)
		return self
	}
}

private extension StandardNetworkController {
	func controllerError (_ error: ControllerError, _ requestId: UUID, _ request: some Request) -> ControllerError {
		logger.log(message: .error(error), requestId: requestId, request: request)
		return error
	}
}
