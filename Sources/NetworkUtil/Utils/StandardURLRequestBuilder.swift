import Foundation

public struct StandardURLRequestBuilder {
	let encoder: RequestBodyEncoder

	public init (encoder: RequestBodyEncoder) {
		self.encoder = encoder
	}
}

public extension StandardURLRequestBuilder {
	func url (_ request: some Request, _ config: URLRequestConfiguration) throws -> URL {
		var basePath = ""

		if let scheme = config.scheme { basePath = "\(scheme)://\(config.address)" }
		if let port = config.port { basePath = "\(basePath):\(port)" }
		if let baseSubpath = config.baseSubpath { basePath = "\(basePath)/\(baseSubpath)" }

		guard
			let path = URL(string: basePath)?.appendingPathComponent(request.path).absoluteString,
			var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponentsCreationFailure("Base path: \(basePath) – Request path: \(request.path)") }

		let query = request.query.merging(config.query) { value, _ in value }
		if !query.isEmpty {
			urlComponents.queryItems = query.map { key, value in .init(name: key, value: value) }
		}

		guard let url = urlComponents.url
		else { throw GeneralError.urlCreationFailure(urlComponents) }

		return url
	}
}

extension StandardURLRequestBuilder: URLRequestBuilder {
	public func build (_ request: some Request, _ config: URLRequestConfiguration) async throws -> URLRequest {
		let url = try url(request, config)
		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = request.method.value
		urlRequest.httpBody = try JSONEncoder().encode(request.body)

		let headers = request.headers.merging(config.headers) { value, _ in value }
		headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		if let builderTimeout = config.timeout {
      urlRequest.timeoutInterval = builderTimeout
    }

		return urlRequest
	}
}

public extension URLRequestBuilder where Self == StandardURLRequestBuilder {
	static func standard (encoder: RequestBodyEncoder = JSONEncoder()) -> Self {
		.init(encoder: encoder)
	}
}
