import Foundation

public struct StandardURLRequestInterceptor: URLRequestInterceptor {
	private let interception: (_ current: URLRequest, _ next: (URLRequest) async throws -> URLRequest) async throws -> URLRequest

	public init (
		_ interception: @escaping (_ current: URLRequest, _ next: (URLRequest) async throws -> URLRequest) async throws -> URLRequest
	) {
		self.interception = interception
	}

	public func perform (_ current: URLRequest, _ next: (URLRequest) async throws -> URLRequest) async throws -> URLRequest {
		try await interception(current, next)
	}
}

public extension URLRequestInterceptor where Self == StandardURLRequestInterceptor {
	static func standard (
		_ interception: @escaping (_ current: URLRequest, _ next: (URLRequest) async throws -> URLRequest) async throws -> URLRequest
	) -> Self {
		.init(interception)
	}
}
