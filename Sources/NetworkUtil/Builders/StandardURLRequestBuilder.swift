import Foundation

public struct StandardURLRequestBuilder {
	public let scheme: String
	public let basePath: String
	public let query: [String: String]
	public let headers: [String: String]

	public init (scheme: String = "http", basePath: String, query: [String: String] = [:], headers: [String: String] = [:]) {
		self.scheme = scheme
		self.basePath = basePath
		self.query = query
		self.headers = headers
	}

	public func url (_ request: Request) throws -> URL {
		let path = URL(string: basePath)?.appendingPathComponent(request.path).absoluteString

		guard
			let path = path,
			var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponentsCreationFailure("Base path: \(basePath) – Request path: \(request.path)") }

		urlComponents.scheme = scheme

		let query = request.query.merging(query) { value, _ in value }
		urlComponents.queryItems = query.map { key, value in .init(name: key, value: value) }

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

		let headers = request.headers.merging(headers) { value, _ in value }
		headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		return urlRequest
	}
}

public extension URLRequestBuilder where Self == StandardURLRequestBuilder {
	static func standard (
		scheme: String = "http",
		basePath: String,
		query: [String: String] = [:],
		headers: [String: String] = [:]
	) -> Self {
		.init(
			scheme: scheme,
			basePath: basePath,
			query: query,
			headers: headers
		)
	}
}
