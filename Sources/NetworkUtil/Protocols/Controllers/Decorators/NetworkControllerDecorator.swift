import Foundation

public protocol NetworkControllerDecorator: NetworkController {
	var networkController: NetworkController { get }
}

public extension NetworkControllerDecorator {
	var configuration: RequestConfiguration { networkController.configuration }

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
		try await networkController.send(
			request,
			response: response,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> NetworkController {
		networkController.configuration(update)
	}

	func replace (configuration: RequestConfiguration) -> NetworkController {
		networkController.replace(configuration: configuration)
	}
}
