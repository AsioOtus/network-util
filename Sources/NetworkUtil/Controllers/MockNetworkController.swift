import Foundation

public final class MockNetworkController <SRQ: Request, SRSM: Decodable>: NetworkController {
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

	public func send <RQ, RS> (
		_ request: RQ,
		response: RS.Type,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> RS.Model)? = nil,
		configurationUpdate: URLRequestConfiguration.Update? = nil,
		interception: URLRequestInterception? = nil,
		sendingDelegate: SendingDelegate<RQ>? = nil
	) async throws -> RS where RQ : Request, RS : Response {
		do {
			_ = try await networkController.send(
				request,
				response: response,
				encoding: encoding,
				decoding: decoding,
				configurationUpdate: configurationUpdate,
				interception: interception,
				sendingDelegate: mockSendingDelegate(sendingDelegate)
			)
		} catch let error as ControllerError {
			guard case .response = error.category else { throw error }
		} catch {
			throw error
		}

		return try StandardResponse(stubData, stubUrlResponse, stubResponseModel) as! RS
	}
}

extension MockNetworkController {
	func mockSendingDelegate <RQ: Request> (_ sendingDelegate: SendingDelegate<RQ>?) -> SendingDelegate<RQ> {
		{ urlSession, urlRequest, requestId, request, _ in
			let sendingDelegate = sendingDelegate ?? { try await $4($0, $1, $2, $3) }

			let (data, urlResponse) = try await sendingDelegate(urlSession, urlRequest, requestId, request) { _, _, _, _ in
				self.resultUrlRequest = urlRequest
				self.resultRequest = (request as! SRQ)

				return (.init(), .init())
			}

			return (data, urlResponse)
		}
	}
}
