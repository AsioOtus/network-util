public protocol ConfigurableAsyncNetworkControllerWrapper: ConfigurableAsyncNetworkController {
  var networkController: ConfigurableAsyncNetworkController { get }
}

extension ConfigurableAsyncNetworkControllerWrapper {
  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableAsyncNetworkController {
    networkController.withConfiguration(update: update)
  }
}
