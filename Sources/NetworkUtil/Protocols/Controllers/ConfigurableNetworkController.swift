import Foundation

public protocol ConfigurableNetworkController: NetworkController {
	var urlRequestConfiguration: URLRequestConfiguration { get }

  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableNetworkController
	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> ConfigurableNetworkController
}
