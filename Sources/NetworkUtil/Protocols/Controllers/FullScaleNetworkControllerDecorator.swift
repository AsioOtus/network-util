import Foundation

public protocol FullScaleNetworkControllerDecorator: FullScaleNetworkController {
  var networkController: FullScaleNetworkController { get }
}

public extension FullScaleNetworkControllerDecorator {
  func send <RQ: Request, RS: Response> (
    _ request: RQ,
    response: RS.Type,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> RS.Model)? = nil,
    configurationUpdate: URLRequestConfiguration.Update? = nil,
		interception: URLRequestInterception? = nil,
		sendingDelegate: SendingDelegate<RQ>? = nil
  ) async throws -> RS {
    try await networkController.send(
      request,
      response: response,
			encoding: encoding,
			decoding: decoding,
      configurationUpdate: configurationUpdate,
			interception: interception,
			sendingDelegate: sendingDelegate
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

	func setSendingDelegate (_ sendingDelegate: SendingDelegateTypeErased?) -> FullScaleNetworkController {
		networkController.setSendingDelegate(sendingDelegate)
	}

  func addInterception (_ interception: @escaping URLRequestInterception) -> FullScaleNetworkController {
    networkController.addInterception(interception)
  }

  var logPublisher: LogPublisher { networkController.logPublisher }

  var logs: AsyncStream<LogRecord> { networkController.logs }
}
