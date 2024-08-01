import Foundation

public final class MockNetworkController <SRQ: Request, SRSM: Decodable>: NetworkController {
	public var logPublisher: LogPublisher {
		Logger().eraseToAnyPublisher()
	}

	public var logs: AsyncStream<LogRecord> {
		Logger().logs
	}

	public let configuration: RequestConfiguration = .empty
	
	public let networkController: NetworkController

	public let stubResponseModel: SRSM
	public let stubData: Data
	public let stubUrlResponse: URLResponse

	public var resultUrlRequest: URLRequest?
	public var resultRequest: SRQ?

	public init(
		stubResponseModel: SRSM,
		stubData: Data = .init(),
		stubUrlResponse: URLResponse = .init(),
		networkController: NetworkController = StandardNetworkController(configuration: .empty)
	) {
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
			_ = try await networkController.send(
				request,
				response: response,
				delegate: delegate,
				configurationUpdate: configurationUpdate
			)
		} catch let error as ControllerError {
			guard case .response = error.category else { throw error }
		} catch {
			throw error
		}

		return try StandardResponse(stubData, stubUrlResponse, stubResponseModel) as! RS
	}

	public func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> NetworkController { self }
	public func replace (configuration: RequestConfiguration) -> NetworkController { self }
}

extension MockNetworkController {
	func mockSendingDelegate <RQ: Request> (_ sending: Sending<RQ>?) -> Sending<RQ> {
		{ urlSession, urlRequest, requestId, request, _ in
			let sending = sending ?? { try await $4($0, $1, $2, $3) }

			let (data, urlResponse) = try await sending(urlSession, urlRequest, requestId, request) { _, _, _, _ in
				self.resultUrlRequest = urlRequest
				self.resultRequest = (request as! SRQ)

				return (.init(), .init())
			}

			return (data, urlResponse)
		}
	}
}
