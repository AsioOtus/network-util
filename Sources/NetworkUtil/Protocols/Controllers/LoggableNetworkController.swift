import Foundation

public protocol LoggableNetworkController: NetworkController {
  var logPublisher: LogPublisher { get }
  var logs: AsyncStream<LogRecord> { get }
}
