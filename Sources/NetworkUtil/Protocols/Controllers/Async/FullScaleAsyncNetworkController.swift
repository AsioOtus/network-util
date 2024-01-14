import Foundation

public protocol FullScaleAsyncNetworkController: AsyncNetworkController {
	var urlRequestConfiguration: URLRequestConfiguration { get }
  var logPublisher: LogPublisher { get }
  var logs: AsyncStream<LogRecord> { get }

  func withConfiguration (update: URLRequestConfiguration.Update) -> FullScaleAsyncNetworkController
	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> FullScaleAsyncNetworkController
  func addInterception (_ interception: @escaping URLRequestInterception) -> FullScaleAsyncNetworkController
  func logging (_ logging: (LogPublisher) -> Void) -> FullScaleAsyncNetworkController
}
