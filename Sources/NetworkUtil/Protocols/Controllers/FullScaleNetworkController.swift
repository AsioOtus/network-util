import Foundation

public protocol FullScaleNetworkController: NetworkController {
	var urlRequestConfiguration: URLRequestConfiguration { get }
  var logPublisher: LogPublisher { get }
  var logs: AsyncStream<LogRecord> { get }

  func withConfiguration (update: URLRequestConfiguration.Update) -> FullScaleNetworkController
	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> FullScaleNetworkController
  func addInterception (_ interception: @escaping URLRequestInterception) -> FullScaleNetworkController
  func logging (_ logging: (LogPublisher) -> Void) -> FullScaleNetworkController
}
