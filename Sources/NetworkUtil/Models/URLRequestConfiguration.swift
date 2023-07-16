import Foundation

public struct URLRequestConfiguration {
	public let scheme: String?
	public let address: String
	public let port: Int?
	public let baseSubpath: String?
	public let query: [String: String]
	public let headers: [String: String]
	public let timeout: Double?
	public let interceptors: [any URLRequestInterceptor]

	public init (
		scheme: String? = nil,
		address: String,
		port: Int? = nil,
		baseSubpath: String? = nil,
		query: [String: String] = [:],
		headers: [String: String] = [:],
		timeout: Double? = nil,
		interceptors: [any URLRequestInterceptor] = []
	) {
		self.scheme = scheme
		self.address = address
		self.port = port
		self.baseSubpath = baseSubpath
		self.query = query
		self.headers = headers
		self.timeout = timeout
		self.interceptors = interceptors
	}
}

public extension URLRequestConfiguration {
	func setScheme (_ scheme: String?) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func setAddress (_ address: String) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func setBaseSubpath (_ baseSubpath: String?) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func setPort (_ port: Int?) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func setQuery (_ query: [String: String]) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func setHeaders (_ headers: [String: String]) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func setTimeout (_ timeout: Double) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func setInterceptors (_ interceptors: [any URLRequestInterceptor]) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func setInterception (_ interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: [.compact(interception)]
		)
	}
}

public extension URLRequestConfiguration {
	func addQuery (key: String, value: String) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: self.query.merging([key: value]) { _, new in new },
			headers: headers,
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func addHeader (key: String, value: String) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers.merging([key: value]) { _, new in new },
			timeout: timeout,
			interceptors: interceptors
		)
	}

	func addInterceptor (_ interceptor: any URLRequestInterceptor) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors + [interceptor]
		)
	}

	func addInterception (_ interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout,
			interceptors: interceptors + [.compact(interception)]
		)
	}
}
