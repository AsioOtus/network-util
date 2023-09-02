public protocol LoggableAsyncNetworkController: AsyncNetworkController {
  @discardableResult
  func logging (_ logging: (Logger) -> Void) -> Self
}

public protocol LoggableAsyncNetworkControllerDecorator: LoggableAsyncNetworkController {
  var networkController: LoggableAsyncNetworkController { get }
}

public extension LoggableAsyncNetworkControllerDecorator {
  func logging (_ logging: (Logger) -> Void) -> LoggableAsyncNetworkController {
    networkController.logging(logging)
  }
}
