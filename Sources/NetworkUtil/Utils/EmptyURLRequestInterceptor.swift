import Foundation

public struct EmptyURLRequestInterceptor: URLRequestInterceptor {
  public func perform (_ current: URLRequest, _ next: (URLRequest) throws -> URLRequest) throws -> URLRequest {
    try next(current)
  }
}

public extension URLRequestInterceptor where Self == EmptyURLRequestInterceptor {
  static func empty () -> Self { .init() }
}
