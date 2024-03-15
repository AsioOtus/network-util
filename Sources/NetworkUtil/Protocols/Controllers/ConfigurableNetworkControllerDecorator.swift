import Foundation

public protocol ConfigurableNetworkControllerDecorator: ConfigurableNetworkController {
	var networkController: ConfigurableNetworkController { get }
}

public extension ConfigurableNetworkControllerDecorator {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		encoding: ((Encodable) throws -> Data)?,
		decoding: ((Data) throws -> RS.Model)?,
		configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> RS {
		try await networkController.send(
			request,
			response: response,
			encoding: encoding,
			decoding: decoding,
			configurationUpdate: configurationUpdate,
			interception: interception
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
