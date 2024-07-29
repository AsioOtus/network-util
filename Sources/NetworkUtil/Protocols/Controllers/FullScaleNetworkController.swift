import Foundation

public protocol FullScaleNetworkController:
	NetworkController,
	ConfigurableNetworkController,
	LoggableNetworkController
{
	var urlRequestConfiguration: URLRequestConfiguration { get }
  var logPublisher: LogPublisher { get }
  var logs: AsyncStream<LogRecord> { get }

  func withConfiguration (update: URLRequestConfiguration.Update) -> FullScaleNetworkController
	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> FullScaleNetworkController
	func addUrlRequestInterception (_ interception: @escaping URLRequestInterception) -> FullScaleNetworkController
	func addUrlResponseInterception (_ interception: @escaping URLResponseInterception) -> FullScaleNetworkController
}
