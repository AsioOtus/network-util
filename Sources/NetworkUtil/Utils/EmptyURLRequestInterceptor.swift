import Foundation

public struct EmptyURLRequestInterceptor: URLRequestInterceptor {
  public func perform (_ current: URLRequest, _ next: (URLRequest) async throws -> URLRequest) async throws -> URLRequest {
    try await next(current)
  }
}

public extension URLRequestInterceptor where Self == EmptyURLRequestInterceptor {
  static func empty () -> Self { .init() }
}
