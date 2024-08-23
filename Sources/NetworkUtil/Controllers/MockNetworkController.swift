import Foundation

public final class MockNetworkController <SRQ: Request, SRSM: Decodable>: NetworkController {
	public var logPublisher: LogPublisher {
		networkController.logPublisher
	}

	public var logs: AsyncStream<LogRecord> {
		networkController.logs
	}

	public let configuration: RequestConfiguration = .empty
	public var delegate: NetworkControllerDelegate = .standard()

	public let networkController: NetworkController

	public let stubResponseModel: SRSM
	public let stubData: Data
	public let stubUrlResponse: URLResponse

	public var resultUrlRequest: URLRequest?
	public var resultRequest: SRQ?

	public init (
		stubResponseModel: SRSM,
		stubData: Data = .init(),
		stubUrlResponse: URLResponse = .init(),
		networkController: NetworkController = StandardNetworkController()
	) {
		self.stubData = stubData
		self.stubUrlResponse = stubUrlResponse
		self.stubResponseModel = stubResponseModel

		self.networkController = networkController
	}

	public init (
		stubResponseModel: SRSM,
		stubData: Data = .init(),
		stubUrlResponse: URLResponse = .init(),
		networkController: NetworkController = StandardNetworkController()
	) where SRQ == StandardRequest<Data> {
		self.stubData = stubData
		self.stubUrlResponse = stubUrlResponse
		self.stubResponseModel = stubResponseModel

		self.networkController = networkController
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
		do {
			let delegate = StandardNetworkControllerSendingDelegate<RQ, RS.Model>(
				decoding: { _, _, _ in self.stubResponseModel as! RS.Model },
				sending: mockSending(delegate.sending)
			)
			.merge(with: delegate)

			let response = try await networkController.send(
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

	public func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> NetworkController { self }
	public func replace (configuration: RequestConfiguration) -> NetworkController { self }
	public func delegate (_ delegate: NetworkControllerDelegate) -> NetworkController { self }
}

extension MockNetworkController {
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
