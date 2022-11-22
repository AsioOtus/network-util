import Foundation

public struct CompactURLRequestInterceptor: URLRequestInterceptor {
	private let interception: (_ urlRequest: URLRequest) throws -> URLRequest

	public init (_ interception: @escaping (_: URLRequest) throws -> URLRequest) {
		self.interception = interception
	}

	public func perform(_ current: URLRequest, _ next: (URLRequest) throws -> URLRequest) throws -> URLRequest {
		let urlRequest = try next(current)
		return try interception(urlRequest)
	}
}

public extension URLRequestInterceptor where Self == CompactURLRequestInterceptor {
	static func compact (
		_ interception: @escaping (_: URLRequest) throws -> URLRequest
	) -> Self {
		.init(interception)
	}
}
