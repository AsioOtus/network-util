import Foundation

public protocol LoggableNetworkControllerDecorator: LoggableNetworkController {
	var networkController: LoggableNetworkController { get }
}

public extension LoggableNetworkControllerDecorator {
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

	var logPublisher: LogPublisher { networkController.logPublisher }
	var logs: AsyncStream<LogRecord> { networkController.logs }
}
