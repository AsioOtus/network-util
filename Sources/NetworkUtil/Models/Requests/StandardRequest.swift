import Foundation

public struct StandardRequest <Body: Encodable>: Request {
	public let method: HTTPMethod
	public let path: String

	public let query: [String: String]
	public let headers: [String: String]

	public let body: Body?

	public init (
		method: HTTPMethod = .get,
		path: String,
		query: [String : String] = [:],
		headers: [String : String] = [:],
		body: Body? = nil
	) {
		self.method = method
		self.path = path
		self.query = query
		self.headers = headers
		self.body = body
	}
}

public extension StandardRequest where Body == Data {
	init (
		method: HTTPMethod = .get,
		path: String,
		query: [String : String] = [:],
		headers: [String : String] = [:]
	) {
		self.method = method
		self.path = path
		self.query = query
		self.headers = headers
		self.body = nil
	}
}

public extension StandardRequest {
	func set (method: HTTPMethod) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	func set (path: String) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	func set (query: [String: String]) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	func set (headers: [String: String]) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	func set (body: Body?) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}
}

public extension Request {
	static func request <B> (
		method: HTTPMethod,
		path: String = "",
		query: [String: String] = [:],
		headers: [String: String] = [:],
		body: B? = nil
	)
	-> StandardRequest<B>
	where Self == StandardRequest<B>
	{
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	static func get (
		_ path: String = "",
		query: [String: String] = [:],
		headers: [String: String] = [:]
	)
	-> StandardRequest<Data>
	where Self == StandardRequest<Data>
	{
		.init(
			method: .get,
			path: path,
			query: query,
			headers: headers
		)
	}

	static func post <B> (
		_ path: String = "",
		query: [String: String] = [:],
		headers: [String: String] = [:],
		body: Body
	)
	-> StandardRequest<B>
	where Self == StandardRequest<B>
	{
		.init(
			method: .post,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}
}
