import Foundation

open class StructuredNetworkControllerDelegate: NetworkControllerDelegate {
	public init (basePath: String, query: [String: String] = [:], headers: [String: String] = [:]) {
		self.basePath = basePath
		self.query = query
		self.headers = headers
	}

	public let basePath: String?
	public let query: [String: String]
	public let headers: [String: String]

	public func url (_ request: StructuredRequest, _ requestInfo: RequestInfo) throws -> URL {
		let path: String?

		if let basePath = basePath {
			path = URL(string: basePath)?.appendingPathComponent(request.path).absoluteString
		} else {
			path = request.path
		}

		guard
			let path = path,
			var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponnetsCreationFailure("Base path: \(basePath ?? "") – Request path: \(request.path)") }

		let query = query.merging(request.query) { value, _ in value }
		urlComponents.queryItems = query.map { key, value in .init(name: key, value: value) }

		guard let url = urlComponents.url
		else { throw GeneralError.urlCreationFailure(urlComponents) }

		return url
	}

	public func urlSession <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLSession {
		try request.urlSession()
	}

	public func urlRequest <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLRequest {
		if let configurableRequest = request as? StructuredRequest {
			let url = try url(configurableRequest, requestInfo)
			var urlRequest = URLRequest(url: url)

			urlRequest.httpMethod = configurableRequest.method
			urlRequest.httpBody = try configurableRequest.body

			let headers = configurableRequest.headers.merging(headers) { value, _ in value }
			headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

			return urlRequest
		}

		return try request.urlRequest()
	}
}
