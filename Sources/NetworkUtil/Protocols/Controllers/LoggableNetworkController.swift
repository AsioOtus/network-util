import Foundation

public protocol LoggableNetworkController: NetworkController {
  var logPublisher: LogPublisher { get }
  var logs: AsyncStream<LogRecord> { get }
  
  @discardableResult
  func logging (_ logging: (LogPublisher) -> Void) -> LoggableNetworkController
}
