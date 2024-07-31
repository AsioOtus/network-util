import Foundation

public struct URLRequestConfiguration: Hashable {
	public typealias Update = (URLRequestConfiguration) -> URLRequestConfiguration

	public static let empty = Self(address: "")

	public let scheme: String?
	public let address: String
	public let port: Int?
	public let baseSubpath: String?
	public let query: Query
	public let headers: Headers
	public let timeout: Double?

	public init (
		scheme: String? = nil,
		address: String,
		port: Int? = nil,
		baseSubpath: String? = nil,
		query: Query = [:],
		headers: Headers = [:],
		timeout: Double? = nil
	) {
		self.scheme = scheme
		self.address = address
		self.port = port
		self.baseSubpath = baseSubpath
		self.query = query
		self.headers = headers
		self.timeout = timeout
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
			timeout: timeout
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
			timeout: timeout
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
			timeout: timeout
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
			timeout: timeout
		)
	}

	func setQuery (_ query: Query) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout
		)
	}

	func setHeaders (_ headers: Headers) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: headers,
			timeout: timeout
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
			timeout: timeout
		)
	}
}

public extension URLRequestConfiguration {
	func addQuery (key: String, value: String?) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: self.query.merging([key: value]) { _, new in new },
			headers: headers,
			timeout: timeout
		)
	}

	func addQuery (_ query: Query) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: self.query.merging(query) { _, new in new },
			headers: headers,
			timeout: timeout
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
			timeout: timeout
		)
	}

	func addHeaders (_ headers: Headers) -> Self {
		.init(
			scheme: scheme,
			address: address,
			port: port,
			baseSubpath: baseSubpath,
			query: query,
			headers: self.headers.merging(headers) { _, new in new },
			timeout: timeout
		)
	}
}
