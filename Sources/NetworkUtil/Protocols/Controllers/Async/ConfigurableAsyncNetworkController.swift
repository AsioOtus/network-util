import Foundation

public protocol ConfigurableAsyncNetworkController: AsyncNetworkController {
	var urlRequestConfiguration: URLRequestConfiguration { get }

  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableAsyncNetworkController
	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> ConfigurableAsyncNetworkController
}

public protocol ConfigurableAsyncNetworkControllerDecorator: ConfigurableAsyncNetworkController {
  var networkController: ConfigurableAsyncNetworkController { get }
}

public extension ConfigurableAsyncNetworkControllerDecorator {
  func send <RQ: Request, RS: Response> (
    _ request: RQ,
    response: RS.Type,
    configurationUpdate: URLRequestConfiguration.Update = { $0 },
    interception: @escaping URLRequestInterception = { $0 }
  ) async throws -> RS {
    try await networkController.send(
      request,
      response: response,
      configurationUpdate: configurationUpdate,
      interception: interception
    )
  }

	var urlRequestConfiguration: URLRequestConfiguration { networkController.urlRequestConfiguration }

  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableAsyncNetworkController {
    networkController.withConfiguration(update: update)
  }

	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> ConfigurableAsyncNetworkController {
		networkController.replaceConfiguration(configuration)
	}
}
