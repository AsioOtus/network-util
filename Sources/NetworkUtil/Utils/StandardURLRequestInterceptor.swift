import Foundation

public struct StandardURLRequestInterceptor: URLRequestInterceptor {
	private let interception: (_ current: URLRequest, _ next: (URLRequest) throws -> URLRequest) throws -> URLRequest

	public init (
		_ interception: @escaping (_ current: URLRequest, _ next: (URLRequest) throws -> URLRequest) throws -> URLRequest
	) {
		self.interception = interception
	}

	public func perform (_ current: URLRequest, _ next: (URLRequest) throws -> URLRequest) throws -> URLRequest {
		try interception(current, next)
	}
}

public extension URLRequestInterceptor where Self == StandardURLRequestInterceptor {
	static func standard (
		_ interception: @escaping (_ current: URLRequest, _ next: (URLRequest) throws -> URLRequest) throws -> URLRequest
	) -> Self {
		.init(interception)
	}
}
