public protocol ConfigurableAsyncNetworkController: AsyncNetworkController {
  func withConfiguration (update: URLRequestConfiguration.Update) -> ConfigurableAsyncNetworkController
}
