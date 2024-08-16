import Foundation

public struct RequestConfiguration: Hashable {
	public var method: Method?
	public var url: URLElements
	public var headers: Headers
	public var timeout: Double?
	public var info: Info

	public init (
		method: Method? = nil,
		url: URLElements = .init(),
		headers: Headers = [:],
		timeout: Double? = nil,
		info: Info = [:]
	) {
		self.method = method
		self.url = url
		self.headers = headers
		self.timeout = timeout
		self.info = info
	}
}

public extension RequestConfiguration {
	static let empty = Self()
}

public extension RequestConfiguration {
	func setMethod (_ method: Method) -> Self {
		var copy = self
		copy.method = method
		return copy
	}

	func setUrl (_ url: URLElements) -> Self {
		var copy = self
		copy.url = url
		return copy
	}

	func setUrl (_ urlComponents: URLComponents) -> Self {
		var copy = self
		copy.url = .init(urlComponents: urlComponents)
		return copy
	}

	func setHeaders (_ headers: Headers) -> Self {
		var copy = self
		copy.headers = headers
		return copy
	}

	func setHeader (key: String, value: String) -> Self {
		var copy = self
		copy.headers = [key: value]
		return copy
	}

	func addHeaders (_ headers: Headers) -> Self {
		var copy = self
		copy.headers.merge(headers) { $1 }
		return copy
	}

	func addHeader (key: String, value: String) -> Self {
		var copy = self
		copy.headers[key] = value
		return copy
	}

	func setInfo (_ info: Info) -> Self {
		var copy = self
		copy.info = info
		return copy
	}

	func setInfo (key: String, value: AnyHashable) -> Self {
		var copy = self
		copy.info = [key: value]
		return copy
	}

	func addInfo (_ info: Headers) -> Self {
		var copy = self
		copy.info.merge(info) { $1 }
		return copy
	}

	func addInfo (key: String, value: AnyHashable) -> Self {
		var copy = self
		copy.info[key] = value
		return copy
	}

	func setTimeout (_ timeout: Double) -> Self {
		var copy = self
		copy.timeout = timeout
		return copy
	}
}

public extension RequestConfiguration {
	func setScheme (_ scheme: String?) -> Self {
		var copy = self
		copy.url = url.setScheme(scheme)
		return copy
	}

	func setUser (_ user: String?) -> Self {
		var copy = self
		copy.url = url.setUser(user)
		return copy
	}

	func setPassword (_ password: String?) -> Self {
		var copy = self
		copy.url = url.setPassword(password)
		return copy
	}

	func setHost (_ host: String?) -> Self {
		var copy = self
		copy.url = url.setHost(host)
		return copy
	}

	func setPort (_ port: Int?) -> Self {
		var copy = self
		copy.url = url.setPort(port)
		return copy
	}

	func setPath (_ path: URLElements.Path) -> Self {
		var copy = self
		copy.url = url.setPath(path)
		return copy
	}

	func setPath (_ path: String) -> Self {
		var copy = self
		copy.url = url.setPath(path)
		return copy
	}

	func addPath (_ path: URLElements.Path) -> Self {
		var copy = self
		copy.url = url.addPath(path)
		return copy
	}

	func addPath (_ path: String) -> Self {
		var copy = self
		copy.url = url.addPath(path)
		return copy
	}

	func setQuery (_ query: [URLQueryItem]) -> Self {
		var copy = self
		copy.url = url.setQuery(query)
		return copy
	}

	func setQuery (_ query: URLQueryItem) -> Self {
		var copy = self
		copy.url = url.setQuery(query)
		return copy
	}

	func addQuery (_ query: [URLQueryItem]) -> Self {
		var copy = self
		copy.url = url.addQuery(query)
		return copy
	}

	func addQuery (_ query: URLQueryItem) -> Self {
		var copy = self
		copy.url = url.addQuery(query)
		return copy
	}

	func setFragment (_ fragment: String?) -> Self {
		var copy = self
		copy.url = url.setFragment(fragment)
		return copy
	}
}


public extension RequestConfiguration {
	func update (_ update: Update?) -> Self {
		update?(self) ?? self
	}

	func url (_ update: (URLElements) -> URLElements) -> Self {
		setUrl(update(self.url))
	}
}

public extension RequestConfiguration {
	func merge (with another: Self) -> Self {
		.init(
			method: another.method ?? self.method,
			url: self.url.merge(with: another.url),
			headers: another.headers.merging(self.headers) { $1 },
			timeout: another.timeout ?? self.timeout,
			info: another.info.merging(self.info) { $1 }
		)
	}
}
