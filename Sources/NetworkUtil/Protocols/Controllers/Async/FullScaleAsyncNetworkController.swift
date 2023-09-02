import Foundation

public protocol FullScaleAsyncNetworkController: ConfigurableAsyncNetworkController, LoggableAsyncNetworkController { }

public protocol FullScaleAsyncNetworkControllerDecorator: FullScaleAsyncNetworkController {
  var networkController: FullScaleAsyncNetworkController { get }
}

public extension FullScaleAsyncNetworkControllerDecorator {
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

  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableAsyncNetworkController {
    networkController.withConfiguration(update: update)
  }

  func logging (_ logging: (Logger) -> Void) -> LoggableAsyncNetworkController {
    networkController.logging(logging)
  }
}
