import Foundation

public protocol LoggableAsyncNetworkController: AsyncNetworkController {
  @discardableResult
  func logging (_ logging: (Logger) -> Void) -> LoggableAsyncNetworkController
}

public protocol LoggableAsyncNetworkControllerDecorator: LoggableAsyncNetworkController {
  var networkController: LoggableAsyncNetworkController { get }
}

public extension LoggableAsyncNetworkControllerDecorator {
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

  func logging (_ logging: (Logger) -> Void) -> LoggableAsyncNetworkController {
    networkController.logging(logging)
  }
}
