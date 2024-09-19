import Foundation

public struct RequestConfiguration: Hashable {
	public var method: Method?
	public var urlComponents: URLComponents
	public var headers: Headers
	public var timeout: Double?
	public var info: Info

	public init (
		method: Method? = nil,
		urlComponents: URLComponents = .init(),
		headers: Headers = [:],
		timeout: Double? = nil,
		info: Info = [:]
	) {
		self.method = method
		self.urlComponents = urlComponents
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

	func setUrlComponents (_ urlComponents: URLComponents) -> Self {
		var copy = self
		copy.urlComponents = urlComponents
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

	func setInfo (key: InfoKey, value: AnyHashable) -> Self {
		var copy = self
		copy.info = [key: value]
		return copy
	}

	func addInfo (_ info: Info) -> Self {
		var copy = self
		copy.info.merge(info) { $1 }
		return copy
	}

	func addInfo (key: InfoKey, value: AnyHashable) -> Self {
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
		copy.urlComponents = urlComponents.setScheme(scheme)
		return copy
	}

	func setUser (_ user: String?) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.setUser(user)
		return copy
	}

	func setPassword (_ password: String?) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.setPassword(password)
		return copy
	}

	func setHost (_ host: String?) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.setHost(host)
		return copy
	}

	func setPort (_ port: Int?) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.setPort(port)
		return copy
	}

	func setPath (_ path: String) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.setPath(path)
		return copy
	}

	func addPath (_ path: String) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.addPath(path)
		return copy
	}

	func setQueryItems (_ queryItems: [URLQueryItem]) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.setQueryItems(queryItems)
		return copy
	}

	func setQueryItem (_ queryItem: URLQueryItem) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.setQueryItem(queryItem)
		return copy
	}

	func addQueryItems (_ queryItems: [URLQueryItem]) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.addQueryItems(queryItems)
		return copy
	}

	func addQueryItem (_ queryItem: URLQueryItem) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.addQueryItem(queryItem)
		return copy
	}

	func setFragment (_ fragment: String?) -> Self {
		var copy = self
		copy.urlComponents = urlComponents.setFragment(fragment)
		return copy
	}
}


public extension RequestConfiguration {
	func update (_ update: Update?) -> Self {
		update?(self) ?? self
	}

	func url (_ update: (URLComponents) -> URLComponents) -> Self {
		setUrlComponents(update(self.urlComponents))
	}
}

public extension RequestConfiguration {
	func merge (with another: Self) -> Self {
		.init(
			method: self.method ?? another.method,
			urlComponents: self.urlComponents.merge(with: another.urlComponents),
			headers: another.headers.merging(self.headers) { $1 },
			timeout: self.timeout ?? another.timeout,
			info: another.info.merging(self.info) { $1 }
		)
	}
}
