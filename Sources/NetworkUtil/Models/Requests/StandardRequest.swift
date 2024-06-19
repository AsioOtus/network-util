import Foundation

public struct StandardRequest <Body: Encodable>: Request {
	public let method: HTTPMethod
	public let path: String

	public let query: Query
	public let headers: Headers

	public let body: Body?

	public init (
		method: HTTPMethod = .get,
		path: String,
		query: Query = [:],
		headers: Headers = [:],
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
		query: Query = [:],
		headers: Headers = [:]
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

	func set (query: Query) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			body: body
		)
	}

	func set (headers: Headers) -> Self {
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

public extension StandardRequest {
	func addQuery (key: String, value: String?) -> Self {
		.init(
			method: method,
			path: path,
			query: self.query.merging([key: value]) { _, new in new },
			headers: headers,
			body: body
		)
	}

	func addQuery (_ query: Query) -> Self {
		.init(
			method: method,
			path: path,
			query: self.query.merging(query) { _, new in new },
			headers: headers,
			body: body
		)
	}

	func addHeader (key: String, value: String) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers.merging([key: value]) { _, new in new },
			body: body
		)
	}

	func addHeaders (_ headers: Headers) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: self.headers.merging(headers) { _, new in new },
			body: body
		)
	}
}


public extension Request {
	static func request <B> (
		method: HTTPMethod,
		path: String = "",
		query: Query = [:],
		headers: Headers = [:],
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
		query: Query = [:],
		headers: Headers = [:]
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
		query: Query = [:],
		headers: Headers = [:],
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
