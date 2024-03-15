import Foundation

public protocol LoggableAsyncNetworkController: NetworkController {
  var logPublisher: LogPublisher { get }
  var logs: AsyncStream<LogRecord> { get }
  
  @discardableResult
  func logging (_ logging: (LogPublisher) -> Void) -> LoggableAsyncNetworkController
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

  var logPublisher: LogPublisher { networkController.logPublisher }
  var logs: AsyncStream<LogRecord> { networkController.logs }

  func logging (_ logging: (LogPublisher) -> Void) -> LoggableAsyncNetworkController {
    networkController.logging(logging)
  }
}
