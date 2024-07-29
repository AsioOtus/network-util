import Foundation

public protocol ConfigurableNetworkControllerDecorator: ConfigurableNetworkController {
	var networkController: ConfigurableNetworkController { get }
}

public extension ConfigurableNetworkControllerDecorator {
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

	var urlRequestConfiguration: URLRequestConfiguration { networkController.urlRequestConfiguration }

	func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableNetworkController {
		networkController.withConfiguration(update: update)
	}

	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> ConfigurableNetworkController {
		networkController.replaceConfiguration(configuration)
	}
}
