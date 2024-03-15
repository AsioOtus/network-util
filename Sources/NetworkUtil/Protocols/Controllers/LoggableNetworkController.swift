import Foundation

public protocol LoggableNetworkController: NetworkController {
  var logPublisher: LogPublisher { get }
  var logs: AsyncStream<LogRecord> { get }
  
  @discardableResult
  func logging (_ logging: (LogPublisher) -> Void) -> LoggableNetworkController
}

public protocol LoggableNetworkControllerDecorator: LoggableNetworkController {
  var networkController: LoggableNetworkController { get }
}

public extension LoggableNetworkControllerDecorator {
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

  var logPublisher: LogPublisher { networkController.logPublisher }
  var logs: AsyncStream<LogRecord> { networkController.logs }

  func logging (_ logging: (LogPublisher) -> Void) -> LoggableNetworkController {
    networkController.logging(logging)
  }
}
