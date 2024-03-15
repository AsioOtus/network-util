import Foundation

public protocol FullScaleNetworkControllerDecorator: FullScaleNetworkController {
  var networkController: FullScaleNetworkController { get }
}

public extension FullScaleNetworkControllerDecorator {
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

	var urlRequestConfiguration: URLRequestConfiguration { networkController.urlRequestConfiguration }

  func withConfiguration (update: URLRequestConfiguration.Update) -> FullScaleNetworkController {
    networkController.withConfiguration(update: update)
  }

	func replaceConfiguration (_ configuration: URLRequestConfiguration) -> FullScaleNetworkController {
		networkController.replaceConfiguration(configuration)
	}

  func addInterception (_ interception: @escaping URLRequestInterception) -> FullScaleNetworkController {
    networkController.addInterception(interception)
  }

  var logPublisher: LogPublisher { networkController.logPublisher }

  var logs: AsyncStream<LogRecord> { networkController.logs }

  func logging (_ logging: (LogPublisher) -> Void) -> FullScaleNetworkController {
    networkController.logging(logging)
  }
}
