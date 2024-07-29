import Foundation

public protocol NetworkControllerDecorator: NetworkController {
	var networkController: NetworkController { get }
}

public extension NetworkControllerDecorator {
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
}
