import Foundation

public struct StandardURLRequestBuilder {
	public var urlRequestConfiguration: URLRequestConfiguration { config }

	private let config: URLRequestConfiguration

	public init (urlRequestConfiguration: URLRequestConfiguration) {
		self.config = urlRequestConfiguration
	}

	public func url (_ request: Request) throws -> URL {
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
	public func build <R: Request> (_ request: R) async throws -> URLRequest {
		let url = try url(request)
		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = request.method.value
		urlRequest.httpBody = try request.body

		let headers = request.headers.merging(config.headers) { value, _ in value }
		headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		if let builderTimeout = config.timeout {
      urlRequest.timeoutInterval = builderTimeout
    }

		let interceptedUrlRequest = try await URLRequestInterceptorChain.create(chainUnits: config.interceptors)?.transform(urlRequest)
    urlRequest = interceptedUrlRequest ?? urlRequest

		return urlRequest
	}
}

public extension StandardAsyncNetworkController {
  convenience init (
    urlSessionBuilder: URLSessionBuilder = .standard(),
    scheme: String? = nil,
    address: String,
    port: Int? = nil,
    baseSubpath: String? = nil,
    query: [String: String] = [:],
    headers: [String: String] = [:],
    timeout: Double? = nil,
    interceptors: [any URLRequestInterceptor] = []
  ) {
    self.init(
      urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: StandardURLRequestBuilder(
				urlRequestConfiguration: .init(
					scheme: scheme,
					address: address,
					port: port,
					baseSubpath: baseSubpath,
					query: query,
					headers: headers,
					timeout: timeout
				)
			),
      interceptors: interceptors
    )
  }

	convenience init (
		urlSessionBuilder: URLSessionBuilder = .standard(),
		urlRequestConfiguration: URLRequestConfiguration,
		interceptors: [any URLRequestInterceptor] = []
	) {
		self.init(
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: StandardURLRequestBuilder(
				urlRequestConfiguration: urlRequestConfiguration
			),
			interceptors: interceptors
		)
	}
}

public extension StandardCombineNetworkController {
  convenience init (
		urlSessionBuilder: URLSessionBuilder = .standard(),
		scheme: String? = nil,
		address: String,
		port: Int? = nil,
		baseSubpath: String? = nil,
		query: [String: String] = [:],
		headers: [String: String] = [:],
		timeout: Double? = nil,
		interceptors: [any URLRequestInterceptor] = []
  ) {
    self.init(
      urlSessionBuilder: urlSessionBuilder,
      urlRequestBuilder: StandardURLRequestBuilder(
				urlRequestConfiguration: .init(
					scheme: scheme,
					address: address,
					port: port,
					baseSubpath: baseSubpath,
					query: query,
					headers: headers,
					timeout: timeout
				)
			),
      interceptors: interceptors
    )
  }

	convenience init (
		urlSessionBuilder: URLSessionBuilder = .standard(),
		urlRequestConfiguration: URLRequestConfiguration,
		interceptors: [any URLRequestInterceptor] = []
	) {
		self.init(
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: StandardURLRequestBuilder(
				urlRequestConfiguration: urlRequestConfiguration
			),
			interceptors: interceptors
		)
	}
}
