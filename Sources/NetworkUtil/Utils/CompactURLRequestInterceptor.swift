import Foundation

public struct CompactURLRequestInterceptor: URLRequestInterceptor {
	public let interception: (_ urlRequest: URLRequest) async throws -> URLRequest

	public init (_ interception: @escaping (_: URLRequest) async throws -> URLRequest) {
		self.interception = interception
	}

	public func perform(_ current: URLRequest, _ next: (URLRequest) async throws -> URLRequest) async throws -> URLRequest {
		let urlRequest = try await next(current)
		return try await interception(urlRequest)
	}
}

public extension URLRequestInterceptor where Self == CompactURLRequestInterceptor {
	static func compact (
		_ interception: @escaping (_: URLRequest) async throws -> URLRequest
	) -> Self {
		.init(interception)
	}
}
