import Foundation

public extension URLComponents {
	init? (address: String) {
		self.init(string: address)
	}

	init (
		scheme: String? = nil,
		user: String? = nil,
		password: String? = nil,
		host: String? = nil,
		port: Int? = nil,
		path: String = "",
		queryItems: [URLQueryItem]? = nil,
		fragment: String? = nil
	) {
		var uc = Self()

		uc.scheme = scheme
		uc.user = user
		uc.password = password
		uc.host = host
		uc.port = port
		uc.path = path
		uc.queryItems = queryItems
		uc.fragment = fragment

		self = uc
	}
}

public extension URLComponents {
	static func http (
		user: String? = nil,
		password: String? = nil,
		host: String? = nil,
		port: Int? = nil,
		path: String = "",
		queryItems: [URLQueryItem]? = nil,
		fragment: String? = nil
	) -> Self {
		.init(
			scheme: "http",
			user: user,
			password: password,
			host: host,
			port: port,
			path: path,
			queryItems: queryItems,
			fragment: fragment
		)
	}

	static func https (
		user: String? = nil,
		password: String? = nil,
		host: String? = nil,
		port: Int? = nil,
		path: String = "",
		queryItems: [URLQueryItem] = [],
		fragment: String? = nil
	) -> Self {
		.init(
			scheme: "https",
			user: user,
			password: password,
			host: host,
			port: port,
			path: path,
			queryItems: queryItems,
			fragment: fragment
		)
	}
}

public extension URLComponents {
	var prefixedPath: String {
		!path.isEmpty && !path.hasPrefix("/")
			? "/" + path
			: path
	}

	var nonPostfixedPath: String {
		!path.isEmpty && path.hasSuffix("/")
			? String(path.dropLast(1))
			: path
	}

	var queryItemsOrEmpty: [URLQueryItem] {
		queryItems ?? []
	}
}

public extension URLComponents {
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

	func setPath (_ path: String) -> Self {
		var copy = self
		copy.path = path
		return copy
	}

	func addPath (_ path: String) -> Self {
		var copy = self
		copy.path += path
		return copy
	}

	func setQueryItems (_ queryItems: [URLQueryItem]?) -> Self {
		var copy = self
		copy.queryItems = queryItems
		return copy
	}

	func setQueryItem (_ queryItem: URLQueryItem) -> Self {
		var copy = self
		copy.queryItems = [queryItem]
		return copy
	}

	func addQueryItems (_ queryItems: [URLQueryItem]) -> Self {
		var copy = self
		copy.queryItems = copy.queryItemsOrEmpty + queryItems
		return copy
	}

	func addQueryItem (_ queryItem: URLQueryItem) -> Self {
		var copy = self
		copy.queryItems = copy.queryItemsOrEmpty + [queryItem]
		return copy
	}

	func setFragment (_ fragment: String?) -> Self {
		var copy = self
		copy.fragment = fragment
		return copy
	}
}

public extension URLComponents {
	func update (_ update: (Self) -> Self) -> Self {
		update(self)
	}
}

public extension URLComponents {
	func merge (with another: Self) -> Self {
		Self(
			scheme: self.scheme ?? another.scheme,
			user: self.user ?? another.user,
			password: self.password ?? another.password,
			host: self.host ?? another.host,
			port: self.port ?? another.port,
			path: another.nonPostfixedPath + self.prefixedPath,
			queryItems: join(another.queryItems, self.queryItems),
			fragment: self.fragment ?? another.fragment
		)
	}
}

fileprivate func join <T> (_ lhs: Array<T>?, _ rhs: Array<T>?) -> Array<T>? {
	switch (lhs, rhs) {
	case (.none, .none): nil
	case (.none, _): rhs
	case (_, .none): lhs
	case (.some(let lhs), .some(let rhs)): lhs + rhs
	}
}
