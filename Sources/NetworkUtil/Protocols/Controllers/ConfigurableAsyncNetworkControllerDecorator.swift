public protocol ConfigurableAsyncNetworkControllerDecorator: ConfigurableAsyncNetworkController {
  var networkController: ConfigurableAsyncNetworkController { get }
}

extension ConfigurableAsyncNetworkControllerDecorator {
  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableAsyncNetworkController {
    networkController.withConfiguration(update: update)
  }
}
