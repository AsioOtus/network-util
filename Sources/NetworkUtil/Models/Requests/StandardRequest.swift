import Foundation

public struct StandardRequest: Request {
	public let method: HTTPMethod
	public let path: String

	public let query: [String: String]
	public let headers: [String: String]

	public let body: Data?

	public init (
		method: HTTPMethod = .get,
		path: String,
		query: [String : String] = [:],
		headers: [String : String] = [:],
		body: Data? = nil
	) {
		self.method = method
		self.path = path
		self.query = query
		self.headers = headers
		self.body = body
	}
}

public extension StandardRequest {
	@discardableResult
	func set (method: HTTPMethod) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	@discardableResult
	func set (path: String) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	@discardableResult
	func set (query: [String: String]) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	@discardableResult
	func set (headers: [String: String]) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	@discardableResult
	func set (body: Data?) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}
}

public extension Request where Self == StandardRequest {
	static func request (
		method: HTTPMethod,
		path: String,
		query: [String: String] = [:],
		headers: [String: String] = [:],
		body: Data? = nil
	) -> StandardRequest {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	static func get (
		_ path: String,
		query: [String: String] = [:],
		headers: [String: String] = [:],
		body: Data? = nil
	) -> StandardRequest {
		.init(
			method: .get,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	static func post (
		_ path: String,
		query: [String: String] = [:],
		headers: [String: String] = [:],
		body: Data
	) -> StandardRequest {
		.init(
			method: .post,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

}
