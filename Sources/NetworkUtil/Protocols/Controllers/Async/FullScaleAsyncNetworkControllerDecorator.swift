import Foundation

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

  func addInterception (_ interception: @escaping URLRequestInterception) -> FullScaleAsyncNetworkController {
    networkController.addInterception(interception)
  }

  var logPublisher: LogPublisher { networkController.logPublisher }

  var logs: AsyncStream<LogRecord> { networkController.logs }

  func logging (_ logging: (LogPublisher) -> Void) -> FullScaleAsyncNetworkController {
    networkController.logging(logging)
  }
}
