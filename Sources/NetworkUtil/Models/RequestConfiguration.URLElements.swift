import Foundation

extension RequestConfiguration {
	public struct URLElements: Hashable {
		public var scheme: String?
		public var user: String?
		public var password: String?
		public var host: String?
		public var port: Int?
		public var path: Path = []
		public var query: [URLQueryItem] = []
		public var fragment: String?

		public init (
			scheme: String? = nil,
			user: String? = nil,
			password: String? = nil,
			host: String? = nil,
			port: Int? = nil,
			path: Path = [],
			query: [URLQueryItem] = [],
			fragment: String? = nil
		) {
			self.scheme = scheme
			self.user = user
			self.password = password
			self.host = host
			self.port = port
			self.path = path
			self.query = query
			self.fragment = fragment
		}

		public init (urlComponents: URLComponents) {
			self.init(
				scheme: urlComponents.scheme,
				user: urlComponents.user,
				password: urlComponents.password,
				host: urlComponents.host,
				port: urlComponents.port,
				path: urlComponents.path.split(separator: "/").map(String.init),
				query: urlComponents.queryItems ?? [],
				fragment: urlComponents.fragment
			)
		}

		public init? (address: String) {
			guard let urlComponents = URLComponents(string: address) else { return nil }
			self.init(urlComponents: urlComponents)
		}
	}
}

public extension RequestConfiguration.URLElements {
	var pathString: String {
		path.joined(separator: "/")
	}

	var prefixedPathString: String {
		let path = pathString

		return !path.isEmpty && !path.hasPrefix("/")
			? "/" + path
			: path
	}

	var queryString: String? {
		var urlComponents = URLComponents()
		urlComponents.queryItems = query
		return urlComponents.query
	}
}

public extension RequestConfiguration.URLElements {
	func setScheme (_ scheme: String?) -> Self {
		var copy = self
		copy.scheme = scheme
		return copy
	}

	func setUser (_ user: String?) -> Self {
		var copy = self
		copy.user = user
		return copy
	}

	func setPassword (_ password: String?) -> Self {
		var copy = self
		copy.password = password
		return copy
	}

	func setHost (_ host: String?) -> Self {
		var copy = self
		copy.host = host
		return copy
	}

	func setPort (_ port: Int?) -> Self {
		var copy = self
		copy.port = port
		return copy
	}

	func setPath (_ path: Path) -> Self {
		var copy = self
		copy.path = path
		return copy
	}

	func setPath (_ path: String) -> Self {
		var copy = self
		copy.path = [path]
		return copy
	}

	func addPath (_ path: Path) -> Self {
		var copy = self
		copy.path += path
		return copy
	}

	func addPath (_ path: String) -> Self {
		var copy = self
		copy.path += [path]
		return copy
	}

	func setQuery (_ query: [URLQueryItem]) -> Self {
		var copy = self
		copy.query = query
		return copy
	}

	func setQuery (_ query: URLQueryItem) -> Self {
		var copy = self
		copy.query = [query]
		return copy
	}

	func addQuery (_ query: [URLQueryItem]) -> Self {
		var copy = self
		copy.query += query
		return copy
	}

	func addQuery (_ query: URLQueryItem) -> Self {
		var copy = self
		copy.query += [query]
		return copy
	}

	func setFragment (_ fragment: String?) -> Self {
		var copy = self
		copy.fragment = fragment
		return copy
	}
}

public extension RequestConfiguration.URLElements {
	func update (_ update: (Self) -> Self) -> Self {
		update(self)
	}
}

public extension RequestConfiguration.URLElements {
	func merge (with another: Self) -> Self {
		RequestConfiguration.URLElements(
			scheme: self.scheme ?? another.scheme,
			user: self.user ?? another.user,
			password: self.password ?? another.password,
			host: self.host ?? another.host,
			port: self.port ?? another.port,
			path: another.path + self.path,
			query: another.query + self.query,
			fragment: self.fragment ?? another.fragment
		)
	}
}

public extension RequestConfiguration.URLElements {
	func urlComponents () -> URLComponents {
		var urlComponents = URLComponents()

		var path = path.joined(separator: "/")
		if !path.isEmpty, !path.starts(with: "/") {
			path = "/" + path
		}

		let query = query.isEmpty ? nil : query

		urlComponents.scheme = scheme
		urlComponents.user = user
		urlComponents.password = password
		urlComponents.host = host
		urlComponents.port = port
		urlComponents.path = path
		urlComponents.queryItems = query
		urlComponents.fragment = fragment

		return urlComponents
	}
}
