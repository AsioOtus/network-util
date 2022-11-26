import Foundation

public struct StandardURLRequestBuilder {
	public let scheme: () throws -> String
	public let basePath: () throws -> String
  public let port: () throws -> Int?
	public let query: () throws -> [String: String]
	public let headers: () throws -> [String: String]

	public init (
		scheme: @escaping () throws -> String = { "http" },
		basePath: @escaping () throws -> String,
    port: @escaping () throws -> Int? = { nil },
		query: @escaping () throws -> [String: String] = { [:] },
		headers: @escaping () throws -> [String: String] = { [:] }
	) {
		self.scheme = scheme
		self.basePath = basePath
    self.port = port
		self.query = query
		self.headers = headers
	}

	public init (
		scheme: String = "http",
		basePath: String,
    port: Int,
		query: [String: String] = [:],
		headers: [String: String] = [:]
	) {
		self.init(
			scheme: { scheme },
      basePath: { basePath },
      port: { port },
      query: { query },
      headers: { headers }
		)
	}

	public func url (_ request: Request) throws -> URL {
    let scheme = try scheme()
    let basePath = try basePath()
    let port = try port()
		let query = try query()

		let path = URL(string: basePath)?.appendingPathComponent(request.path).absoluteString

		guard
			let path = path,
			var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponentsCreationFailure("Base path: \(basePath) – Request path: \(request.path)") }

		urlComponents.scheme = scheme
    urlComponents.port = port

		let requestQuery = request.query.merging(query) { value, _ in value }
		urlComponents.queryItems = requestQuery.map { key, value in .init(name: key, value: value) }

		guard let url = urlComponents.url
		else { throw GeneralError.urlCreationFailure(urlComponents) }

		return url
	}
}

extension StandardURLRequestBuilder: URLRequestBuilder {
	public func build <R: Request> (_ request: R) throws -> URLRequest {
		let url = try url(request)
		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = request.method.value
		urlRequest.httpBody = try request.body

    let headers = try headers()
		let requestHeaders = request.headers.merging(headers) { value, _ in value }
		requestHeaders.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		return urlRequest
	}
}

public extension URLRequestBuilder where Self == StandardURLRequestBuilder {
	static func standard (
		scheme: @escaping () throws -> String = { "http" },
		basePath: @escaping () throws -> String,
		query: @escaping () throws -> [String: String] = { [:] },
		headers: @escaping () throws -> [String: String] = { [:] }
	) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}
}

public extension StandardURLRequestBuilder {
	func set (scheme: @escaping () -> String) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}

	func set (basePath: @escaping () -> String) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}

	func set (query: @escaping () -> [String: String]) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}

	func set (headers: @escaping () -> [String: String]) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}
}
