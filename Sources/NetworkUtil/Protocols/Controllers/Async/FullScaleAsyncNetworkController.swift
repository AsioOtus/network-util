import Foundation

public protocol FullScaleAsyncNetworkController: AsyncNetworkController {
  var logPublisher: LogPublisher { get }

  func withConfiguration (update: URLRequestConfiguration.Update) -> FullScaleAsyncNetworkController
  func logging (_ logging: (LogPublisher) -> Void) -> FullScaleAsyncNetworkController
}

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

  func withConfiguration (update: URLRequestConfiguration.Update) -> FullScaleAsyncNetworkController {
    networkController.withConfiguration(update: update)
  }

  func logging (_ logging: (LogPublisher) -> Void) -> FullScaleAsyncNetworkController {
    networkController.logging(logging)
  }
}
