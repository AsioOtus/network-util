import Foundation

public protocol FullScaleNetworkControllerDecorator: FullScaleNetworkController {
  var networkController: FullScaleNetworkController { get }
}

public extension FullScaleNetworkControllerDecorator {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		responseType: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: URLRequestConfiguration.Update? = nil
	) async throws -> RS {
		try await networkController.send(
			request,
			responseType: responseType,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	var urlRequestConfiguration: URLRequestConfiguration { networkController.urlRequestConfiguration }

  func withConfiguration (update: URLRequestConfiguration.Update) -> FullScaleNetworkController {
    networkController.withConfiguration(update: update)
  }

	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> FullScaleNetworkController {
		networkController.replaceConfiguration(configuration)
	}

	func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableNetworkController {
		networkController.withConfiguration(update: update)
	}

	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> ConfigurableNetworkController {
		networkController.replaceConfiguration(configuration)
	}

	func addUrlRequestInterception (_ interception: @escaping URLRequestInterception) -> FullScaleNetworkController {
		networkController.addUrlRequestInterception(interception)
	}

	func addUrlResponseInterception (_ interception: @escaping URLResponseInterception) -> FullScaleNetworkController {
		networkController.addUrlResponseInterception(interception)
	}

  var logPublisher: LogPublisher { networkController.logPublisher }

  var logs: AsyncStream<LogRecord> { networkController.logs }
}
