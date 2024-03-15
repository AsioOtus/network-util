import Foundation

public protocol ConfigurableNetworkController: NetworkController {
	var urlRequestConfiguration: URLRequestConfiguration { get }

  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableNetworkController
	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> ConfigurableNetworkController
}

public protocol ConfigurableNetworkControllerDecorator: ConfigurableNetworkController {
  var networkController: ConfigurableNetworkController { get }
}

public extension ConfigurableNetworkControllerDecorator {
  func send <RQ: Request, RS: Response> (
    _ request: RQ,
    response: RS.Type,
		encoding: ((Encodable) throws -> Data)?,
    configurationUpdate: URLRequestConfiguration.Update = { $0 },
    interception: @escaping URLRequestInterception = { $0 }
  ) async throws -> RS {
    try await networkController.send(
      request,
      response: response,
			encoding: encoding,
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
