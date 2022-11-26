import Foundation

public struct StandardURLRequestBuilder {
	public let scheme: () -> String
	public let basePath: () -> String
	public let query: () -> [String: String]
	public let headers: () -> [String: String]

	public init (
		scheme: @escaping () -> String = { "http" },
		basePath: @escaping () -> String,
		query: @escaping () -> [String: String] = { [:] },
		headers: @escaping () -> [String: String] = { [:] }
	) {
		self.scheme = scheme
		self.basePath = basePath
		self.query = query
		self.headers = headers
	}

	public init (
		scheme: String = "http",
		basePath: String,
		query: [String: String] = [:],
		headers: [String: String] = [:]
	) {
		self.init(
			scheme: { scheme },
      basePath: { basePath },
      query: { query },
      headers: { headers }
		)
	}

	public func url (_ request: Request) throws -> URL {
		let basePath = basePath()
		let scheme = scheme()
		let query = query()

		let path = URL(string: basePath)?.appendingPathComponent(request.path).absoluteString

		guard
			let path = path,
			var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponentsCreationFailure("Base path: \(basePath) – Request path: \(request.path)") }

		urlComponents.scheme = scheme

		let requestQuery = request.query.merging(query) { value, _ in value }
		urlComponents.queryItems = requestQuery.map { key, value in .init(name: key, value: value) }

		guard let url = urlComponents.url
		else { throw GeneralError.urlCreationFailure(urlComponents) }

		return url
	}
}

extension StandardURLRequestBuilder: URLRequestBuilder {
	public func build <R: Request> (_ request: R) throws -> URLRequest {
		let headers = headers()

		let url = try url(request)
		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = request.method.value
		urlRequest.httpBody = try request.body

		let requestHeaders = request.headers.merging(headers) { value, _ in value }
		requestHeaders.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		return urlRequest
	}
}

public extension URLRequestBuilder where Self == StandardURLRequestBuilder {
	static func standard (
		scheme: @escaping @autoclosure () -> String = "http",
		basePath: @escaping @autoclosure () -> String,
		query: @escaping @autoclosure () -> [String: String] = [:],
		headers: @escaping @autoclosure () -> [String: String] = [:]
	) -> Self {
		.init(
			scheme: scheme(),
			basePath: basePath(),
			query: query(),
			headers: headers()
		)
	}

	static func standard (
		scheme: @escaping () -> String = { "http" },
		basePath: @escaping () -> String,
		query: @escaping () -> [String: String] = { [:] },
		headers: @escaping () -> [String: String] = { [:] }
	) -> Self {
		.init(
			scheme: scheme(),
			basePath: basePath(),
			query: query(),
			headers: headers()
		)
	}
}

public extension StandardURLRequestBuilder {
	func set (scheme: @escaping @autoclosure () -> String) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}

	func set (basePath: @escaping @autoclosure () -> String) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}

	func set (query: @escaping @autoclosure () -> [String: String]) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}

	func set (headers: @escaping @autoclosure () -> [String: String]) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}
}
