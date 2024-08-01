import Foundation

public struct StandardURLRequestBuilder {
	public init () { }
}

extension StandardURLRequestBuilder: URLRequestBuilder {
	public func build (_ address: String?, _ configuration: RequestConfiguration, _ body: Data?) throws -> URLRequest {
		let url = try buildUrl(address, configuration)

		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = configuration.method?.value
		urlRequest.httpBody = body

		let headers = configuration.headers
		headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		if let builderTimeout = configuration.timeout {
      urlRequest.timeoutInterval = builderTimeout
    }

		return urlRequest
	}

	func buildUrl (_ address: String?, _ configuration: RequestConfiguration) throws -> URL {
		if let address {
			guard let url = URL(string: address) else { throw URLCreationError.addressFailure(address) }
			return url
		} else {
			let urlComponents = configuration.url.urlComponents()
			guard let url = urlComponents.url else { throw URLCreationError.urlComponentsFailure(urlComponents) }
			return url
		}
	}
}

public extension URLRequestBuilder where Self == StandardURLRequestBuilder {
	static func standard () -> Self {
		.init()
	}
}
