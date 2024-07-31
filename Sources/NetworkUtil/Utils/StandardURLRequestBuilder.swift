import Foundation

public struct StandardURLRequestBuilder {
	public init () { }
}

public extension StandardURLRequestBuilder {
	func url (_ request: some Request, _ config: URLRequestConfiguration) throws -> URL {
		var basePath = config.address

		if let scheme = config.scheme { basePath = "\(scheme)://\(basePath)" }
		if let port = config.port { basePath = "\(basePath):\(port)" }
		if let baseSubpath = config.baseSubpath { basePath = "\(basePath)/\(baseSubpath)" }

		let url = if basePath.isEmpty {
			URL(string: request.path)
		} else {
			URL(string: basePath)?.appendingPathComponent(request.path)
		}

		guard
			let path = url?.absoluteString,
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
	public func build (_ request: some Request, _ body: Data?, _ config: URLRequestConfiguration) throws -> URLRequest {
		let url = try url(request, config)
		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = request.method.value
		urlRequest.httpBody = body

		let headers = request.headers.merging(config.headers) { value, _ in value }
		headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		if let builderTimeout = config.timeout {
      urlRequest.timeoutInterval = builderTimeout
    }

		return urlRequest
	}
}

public extension URLRequestBuilder where Self == StandardURLRequestBuilder {
	static func standard () -> Self {
		.init()
	}
}
