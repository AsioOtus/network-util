import Foundation

public struct StandardURLRequestBuilder {
	public let scheme: () throws -> String?
  public let address: () throws -> String
  public let port: () throws -> Int?
  public let baseSubpath: () throws -> String?
	public let query: () throws -> [String: String]
	public let headers: () throws -> [String: String]

	public init (
		scheme: @escaping () throws -> String? = { nil },
    address: @escaping () throws -> String,
    port: @escaping () throws -> Int? = { nil },
    baseSubpath: @escaping () throws -> String? = { nil },
		query: @escaping () throws -> [String: String] = { [:] },
		headers: @escaping () throws -> [String: String] = { [:] }
	) {
		self.scheme = scheme
    self.address = address
    self.port = port
    self.baseSubpath = baseSubpath
		self.query = query
		self.headers = headers
	}

	public init (
		scheme: String? = nil,
    address: String,
    port: Int? = nil,
    baseSubpath: String? = nil,
		query: [String: String] = [:],
		headers: [String: String] = [:]
	) {
		self.init(
			scheme: { scheme },
      address: { address },
      port: { port },
      baseSubpath: { baseSubpath },
      query: { query },
      headers: { headers }
		)
	}

	public func url (_ request: Request) throws -> URL {
    let scheme = try scheme()
    let address = try address()
    let baseSubpath = try baseSubpath()
    let port = try port()

    var subpath = ""

    if let scheme = scheme { subpath = "\(scheme)://\(address)" }
    if let port = port { subpath = "\(subpath):\(port)" }
    if let baseSubpath = baseSubpath { subpath = "\(subpath)/\(baseSubpath)" }

		guard
			let path = URL(string: subpath)?.appendingPathComponent(request.path).absoluteString,
			var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponentsCreationFailure("Base path: \(subpath) – Request path: \(request.path)") }

    let query = try query()
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
		scheme: @escaping () throws -> String? = { nil },
    address: @escaping () throws -> String,
    port: @escaping () throws -> Int? = { nil },
    baseSubpath: @escaping () throws -> String? = { nil },
		query: @escaping () throws -> [String: String] = { [:] },
		headers: @escaping () throws -> [String: String] = { [:] }
	) -> Self {
		.init(
			scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
			query: query,
			headers: headers
		)
	}
}

public extension StandardURLRequestBuilder {
	func set (scheme: @escaping () -> String?) -> Self {
		.init(
			scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
			query: query,
			headers: headers
		)
	}

  func set (address: @escaping () -> String) -> Self {
    .init(
      scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
      query: query,
      headers: headers
    )
  }

	func set (baseSubpath: @escaping () -> String?) -> Self {
		.init(
			scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
			query: query,
			headers: headers
		)
	}

  func set (port: @escaping () -> Int?) -> Self {
    .init(
      scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
      query: query,
      headers: headers
    )
  }

	func set (query: @escaping () -> [String: String]) -> Self {
		.init(
			scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
			query: query,
			headers: headers
		)
	}

	func set (headers: @escaping () -> [String: String]) -> Self {
		.init(
			scheme: scheme,
      address: address,
      port: port,
      baseSubpath: baseSubpath,
			query: query,
			headers: headers
		)
	}
}
