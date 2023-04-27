import Foundation

public struct StandardURLRequestBuilder {
	public let scheme: () throws -> String?
  public let address: () throws -> String
  public let port: () throws -> Int?
  public let baseSubpath: () throws -> String?
	public let query: [() throws -> [String: String]]
	public let headers: [() throws -> [String: String]]
  public let timeout: () throws -> Double?
  public let interceptors: [any URLRequestInterceptor]

	public init (
		scheme: @escaping () throws -> String? = { nil },
    address: @escaping () throws -> String,
    port: @escaping () throws -> Int? = { nil },
    baseSubpath: @escaping () throws -> String? = { nil },
		query: [() throws -> [String: String]] = [{ [:] }],
		headers: [() throws -> [String: String]] = [{ [:] }],
    timeout: @escaping () throws -> Double? = { nil },
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
		self.init(
			scheme: { scheme },
      address: { address },
      port: { port },
      baseSubpath: { baseSubpath },
      query: [{ query }],
      headers: [{ headers }],
      timeout: { timeout },
      interceptors: interceptors
		)
	}

	public func url (_ request: Request) throws -> URL {
    let scheme = try scheme()
    let address = try address()
    let baseSubpath = try baseSubpath()
    let port = try port()

    var basePath = ""

    if let scheme = scheme { basePath = "\(scheme)://\(address)" }
    if let port = port { basePath = "\(basePath):\(port)" }
    if let baseSubpath = baseSubpath { basePath = "\(basePath)/\(baseSubpath)" }

		guard
			let path = URL(string: basePath)?.appendingPathComponent(request.path).absoluteString,
			var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponentsCreationFailure("Base path: \(basePath) – Request path: \(request.path)") }

    let query = try query.reduce([String: String]()) { try $0.merging($1()) { _, key in key } }
		let requestQuery = request.query.merging(query) { value, _ in value }
    if !requestQuery.isEmpty {
      urlComponents.queryItems = requestQuery.map { key, value in .init(name: key, value: value) }
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

    let headers = try headers.reduce([String: String]()) { try $0.merging($1()) { _, key in key } }
		let requestHeaders = request.headers.merging(headers) { value, _ in value }
		requestHeaders.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

    if let builderTimeout = try timeout() {
      urlRequest.timeoutInterval = builderTimeout
    }

    let interceptedUrlRequest = try await URLRequestInterceptorChain.create(chainUnits: interceptors)?.transform(urlRequest)
    urlRequest = interceptedUrlRequest ?? urlRequest

		return urlRequest
	}
}

public extension URLRequestBuilder where Self == StandardURLRequestBuilder {
	static func standard (
		scheme: @escaping () throws -> String? = { nil },
    address: @escaping () throws -> String,
    port: @escaping () throws -> Int? = { nil },
    baseSubpath: @escaping () throws -> String? = { nil },
		query: [() throws -> [String: String]] = [{ [:] }],
		headers: [() throws -> [String: String]] = [{ [:] }],
    timeout: @escaping () throws -> Double? = { nil },
    interceptors: [any URLRequestInterceptor] = []
	) -> Self {
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

  static func standard (
    scheme: String? = nil,
    address: String,
    port: Int? = nil,
    baseSubpath: String? = nil,
    query: [String: String] = [:],
    headers: [String: String] = [:],
    timeout: Double? = nil,
    interceptors: [any URLRequestInterceptor] = []
  ) -> Self {
    .init(
      scheme: { scheme },
      address: { address },
      port: { port },
      baseSubpath: { baseSubpath },
      query: [{ query }],
      headers: [{ headers }],
      timeout: { timeout },
      interceptors: interceptors
    )
  }
}

public extension StandardURLRequestBuilder {
  func setScheme (_ scheme: @escaping () throws -> String?) -> Self {
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

  func setAddress (_ address: @escaping () throws -> String) -> Self {
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

  func setBaseSubpath (_ baseSubpath: @escaping () throws -> String?) -> Self {
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

  func setPort (_ port: @escaping () throws -> Int?) -> Self {
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

  func setQuery (_ query: [() throws -> [String: String]]) -> Self {
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

  func setHeaders (_ headers: [() throws -> [String: String]]) -> Self {
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

  func setTimeout (_ timeout: @escaping () throws -> Double) -> Self {
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

public extension StandardURLRequestBuilder {
  func addQuery (_ query: @escaping () throws -> [String: String]) -> Self {
    .init(
      scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
      query: self.query + [query],
      headers: headers,
      timeout: timeout,
      interceptors: interceptors
    )
  }

  func addHeader (_ header: @escaping () throws -> [String: String]) -> Self {
    .init(
      scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
      query: query,
      headers: headers + [header],
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

public extension StandardAsyncNetworkController {
  convenience init (
    urlSessionBuilder: URLSessionBuilder = .standard(),
    scheme: @escaping () throws -> String? = { nil },
    address: @escaping () throws -> String,
    port: @escaping () throws -> Int? = { nil },
    baseSubpath: @escaping () throws -> String? = { nil },
    query: [() throws -> [String: String]] = [{ [:] }],
    headers: [() throws -> [String: String]] = [{ [:] }],
    timeout: @escaping () throws -> Double? = { nil },
    interceptors: [any URLRequestInterceptor] = []
  ) {
    self.init(
      urlSessionBuilder: urlSessionBuilder,
      urlRequestBuilder: .standard(
        scheme: scheme,
        address: address,
        port: port,
        baseSubpath: baseSubpath,
        query: query,
        headers: headers,
        timeout: timeout
      ),
      interceptors: interceptors
    )
  }

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
      urlRequestBuilder: .standard(
        scheme: { scheme },
        address: { address },
        port: { port },
        baseSubpath: { baseSubpath },
        query: [{ query }],
        headers: [{ headers }],
        timeout: { timeout }
      ),
      interceptors: interceptors
    )
  }
}

public extension StandardCombineNetworkController {
  convenience init (
    urlSessionBuilder: URLSessionBuilder = .standard(),
    scheme: @escaping () throws -> String? = { nil },
    address: @escaping () throws -> String,
    port: @escaping () throws -> Int? = { nil },
    baseSubpath: @escaping () throws -> String? = { nil },
    query: [() throws -> [String: String]] = [{ [:] }],
    headers: [() throws -> [String: String]] = [{ [:] }],
    timeout: @escaping () throws -> Double? = { nil },
    interceptors: [any URLRequestInterceptor] = []
  ) {
    self.init(
      urlSessionBuilder: urlSessionBuilder,
      urlRequestBuilder: .standard(
        scheme: scheme,
        address: address,
        port: port,
        baseSubpath: baseSubpath,
        query: query,
        headers: headers,
        timeout: timeout
      ),
      interceptors: interceptors
    )
  }

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
      urlRequestBuilder: .standard(
        scheme: { scheme },
        address: { address },
        port: { port },
        baseSubpath: { baseSubpath },
        query: [{ query }],
        headers: [{ headers }],
        timeout: { timeout }
      ),
      interceptors: interceptors
    )
  }
}
