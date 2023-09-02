public protocol ConfigurableAsyncNetworkControllerDecorator: ConfigurableAsyncNetworkController {
  var networkController: ConfigurableAsyncNetworkController { get }
}

public extension ConfigurableAsyncNetworkControllerDecorator {
  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableAsyncNetworkController {
    networkController.withConfiguration(update: update)
  }
}
