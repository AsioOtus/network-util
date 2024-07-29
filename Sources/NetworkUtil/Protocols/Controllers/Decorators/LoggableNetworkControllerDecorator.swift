import Foundation

public protocol LoggableNetworkControllerDecorator: LoggableNetworkController {
	var networkController: LoggableNetworkController { get }
}

public extension LoggableNetworkControllerDecorator {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		responseType: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: URLRequestConfiguration.Update? = nil
	) async throws -> RS {
		try await networkController.send(
			request,
			responseType: responseType,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	var logPublisher: LogPublisher { networkController.logPublisher }
	var logs: AsyncStream<LogRecord> { networkController.logs }
}
