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

	public var resultUrlRequest: URLRequest?
	public var resultRequest: SRQ?

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
		do {
			let delegate = StandardURLClientSendingDelegate<RQ, RS.Model>(
				decoding: { _, _, _ in self.stubResponseModel as! RS.Model },
				sending: mockSending(delegate.sending)
			)
			.merge(with: delegate)

			let response = try await urlClient.send(
				request,
				response: response,
				delegate: delegate,
				configurationUpdate: configurationUpdate
			)

			return response
		} catch {
			throw error
		}
	}

    public func requestEntities <RQ: Request, RS: Response> (
        _ request: RQ,
        response: RS.Type,
        delegate: some URLClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> (URLSession, URLRequest, RequestConfiguration) {
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

extension MockURLClient {
	func mockSending <RQ: Request> (_ sending: Sending<RQ>?) -> Sending<RQ> {
		{ sendingModel, _ in
			let sending = sending ?? emptySending()

			let (data, urlResponse) = try await sending(sendingModel) { _, urlRequest in
				self.resultUrlRequest = urlRequest
				self.resultRequest = (sendingModel.request as! SRQ)

				return (self.stubData, self.stubUrlResponse)
			}

			return (data, urlResponse)
		}
	}
}
