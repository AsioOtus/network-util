import Foundation

public protocol NetworkControllerDecorator: NetworkController {
	var networkController: NetworkController { get }
}

public extension NetworkControllerDecorator {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> RS.Model)? = nil,
		configurationUpdate: URLRequestConfiguration.Update? = nil,
		interception: URLRequestInterception? = nil,
		sending: Sending<RQ>? = nil
	) async throws -> RS {
		try await networkController.send(
			request,
			response: response,
			encoding: encoding,
			decoding: decoding,
			configurationUpdate: configurationUpdate,
			interception: interception,
			sending: sending
		)
	}
}
