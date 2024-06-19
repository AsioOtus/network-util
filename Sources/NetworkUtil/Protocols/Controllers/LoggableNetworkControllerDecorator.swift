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
		configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 },
		sendingDelegate: SendingDelegate? = nil
	) async throws -> RS {
		try await networkController.send(
			request,
			response: response,
			encoding: encoding,
			decoding: decoding,
			configurationUpdate: configurationUpdate,
			interception: interception,
			sendingDelegate: sendingDelegate
		)
	}

	var logPublisher: LogPublisher { networkController.logPublisher }
	var logs: AsyncStream<LogRecord> { networkController.logs }

	func logging (_ logging: (LogPublisher) -> Void) -> LoggableNetworkController {
		networkController.logging(logging)
	}
}
