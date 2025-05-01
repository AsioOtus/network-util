import Combine
import Foundation

public final class MockAPIClient <SRQ: Request, SRSM: Decodable>: APIClient {
	public var logPublisher: AnyPublisher<LogRecord, Never> {
		apiClient.logPublisher
	}

	public let configuration: RequestConfiguration = .empty
	public var delegate: APIClientDelegate = .standard()

	public let apiClient: APIClient

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
		apiClient: APIClient = StandardAPIClient()
	) {
		self.stubData = stubData
		self.stubUrlResponse = stubUrlResponse
		self.stubResponseModel = stubResponseModel

		self.apiClient = apiClient
	}

	public init (
		stubResponseModel: SRSM,
		stubData: Data = .init(),
		stubUrlResponse: URLResponse = .init(),
		apiClient: APIClient = StandardAPIClient()
	) where SRQ == StandardRequest<Data> {
		self.stubData = stubData
		self.stubUrlResponse = stubUrlResponse
		self.stubResponseModel = stubResponseModel

		self.apiClient = apiClient
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some APIClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
        (resultUrlSession, resultUrlRequest, resultRequestConfiguration) = try await requestEntities(
            request,
            response: response,
            delegate: delegate,
            configurationUpdate: configurationUpdate
        )

        return RS(data: stubData, urlResponse: stubUrlResponse, model: stubResponseModel as! RS.Model)
	}

    public func requestEntities <RQ: Request, RS: Response> (
        _ request: RQ,
        response: RS.Type,
        delegate: some APIClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> (urlSession: URLSession, urlRequest: URLRequest, configuration: RequestConfiguration) {
        try await apiClient.requestEntities(
            request,
            response: response,
            delegate: delegate,
            configurationUpdate: configurationUpdate
        )
    }

	public func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> APIClient { self }
	public func setConfiguration (_ configuration: RequestConfiguration) -> APIClient { self }
	public func delegate (_ delegate: APIClientDelegate) -> APIClient { self }
}
