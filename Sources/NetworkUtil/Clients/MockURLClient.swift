import Combine
import Foundation

public final class MockURLClient <SRQ: Request, SRSM: Decodable>: URLClient {
	public var logPublisher: AnyPublisher<LogRecord, Never> {
		urlClient.logPublisher
	}

	public let configuration: RequestConfiguration = .empty
	public var delegate: URLClientDelegate = .standard()

	public let urlClient: URLClient

	public let stubResponseModel: SRSM
	public let stubData: Data
	public let stubUrlResponse: URLResponse

    public var resultUrlSession: URLSession?
	public var resultUrlRequest: URLRequest?
    public var resultRequestConfiguration: RequestConfiguration?

	public init (
		stubResponseModel: SRSM,
		stubData: Data = .init(),
		stubUrlResponse: URLResponse = .init(),
		urlClient: URLClient = StandardURLClient()
	) {
		self.stubData = stubData
		self.stubUrlResponse = stubUrlResponse
		self.stubResponseModel = stubResponseModel

		self.urlClient = urlClient
	}

	public init (
		stubResponseModel: SRSM,
		stubData: Data = .init(),
		stubUrlResponse: URLResponse = .init(),
		urlClient: URLClient = StandardURLClient()
	) where SRQ == StandardRequest<Data> {
		self.stubData = stubData
		self.stubUrlResponse = stubUrlResponse
		self.stubResponseModel = stubResponseModel

		self.urlClient = urlClient
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some URLClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
        (resultUrlSession, resultUrlRequest, resultRequestConfiguration) = try await requestEntities(
            request,
            response: response,
            delegate: delegate,
            configurationUpdate: configurationUpdate
        )

        return try RS(stubData, stubUrlResponse, stubResponseModel as! RS.Model)
	}

    public func requestEntities <RQ: Request, RS: Response> (
        _ request: RQ,
        response: RS.Type,
        delegate: some URLClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> (urlSession: URLSession, urlRequest: URLRequest, configuration: RequestConfiguration) {
        try await urlClient.requestEntities(
            request,
            response: response,
            delegate: delegate,
            configurationUpdate: configurationUpdate
        )
    }

	public func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> URLClient { self }
	public func setConfiguration (_ configuration: RequestConfiguration) -> URLClient { self }
	public func delegate (_ delegate: URLClientDelegate) -> URLClient { self }
}
