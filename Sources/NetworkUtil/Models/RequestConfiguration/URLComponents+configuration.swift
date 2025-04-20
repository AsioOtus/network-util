import Foundation

public extension URLComponents {
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
        self = .init()

		self.scheme = scheme
        self.user = user
        self.password = password
        self.host = host
        self.port = port
        self.path = path
        self.queryItems = queryItems
        self.fragment = fragment
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
        path.prefixedWithSlash
	}

	var queryItemsOrEmpty: [URLQueryItem] {
		queryItems ?? []
	}
}

public extension URLComponents {
	func scheme (_ scheme: String?) -> Self {
		var copy = self
		copy.scheme = scheme
		return copy
	}

	func user (_ user: String?) -> Self {
		var copy = self
		copy.user = user
		return copy
	}

	func password (_ password: String?) -> Self {
		var copy = self
		copy.password = password
		return copy
	}

	func host (_ host: String?) -> Self {
		var copy = self
		copy.host = host
		return copy
	}

	func port (_ port: Int?) -> Self {
		var copy = self
		copy.port = port
		return copy
	}

	func setPath (_ path: String) -> Self {
		var copy = self
        copy.path = path.prefixedWithSlash
		return copy
	}

	func path (_ path: String) -> Self {
		var copy = self
        copy.path = join(copy.path, path)
		return copy
	}

    func setRawPath (_ path: String) -> Self {
        var copy = self
        copy.path = path
        return copy
    }

    func rawPath (_ path: String) -> Self {
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

	func queryItems (_ queryItems: [URLQueryItem]) -> Self {
		var copy = self
		copy.queryItems = copy.queryItemsOrEmpty + queryItems
		return copy
	}

	func queryItem (_ queryItem: URLQueryItem) -> Self {
		var copy = self
		copy.queryItems = copy.queryItemsOrEmpty + [queryItem]
		return copy
	}

	func fragment (_ fragment: String?) -> Self {
		var copy = self
		copy.fragment = fragment
		return copy
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
            path: join(another.path, self.path),
			queryItems: join(another.queryItems, self.queryItems),
			fragment: self.fragment ?? another.fragment
		)
	}

    func merge (into another: Self) -> Self {
        another.merge(with: self)
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

fileprivate func join (_ lhs: String, _ rhs: String) -> String {
    lhs.withoutSlashPostfix + rhs.prefixedWithSlash
}

fileprivate extension String {
    var prefixedWithSlash: Self {
        !isEmpty && !hasPrefix("/")
            ? "/" + self
            : self
    }

    var postfixedWithSlash: Self {
        !isEmpty && !hasSuffix("/")
            ? self + "/"
            : self
    }

    var withoutSlashPrefix: Self {
        !isEmpty && hasPrefix("/")
            ? .init(dropFirst(1))
            : self
    }

    var withoutSlashPostfix: Self {
        !isEmpty && hasSuffix("/")
            ? .init(dropLast(1))
            : self
    }
}
