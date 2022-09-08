public struct StandardRequest: StructuredRequest {
    public let method: HTTPMethod

    public let scheme: String?
    public let basePath: String?
    public let subpath: String

    public let query: [String: String]
    public let headers: [String: String]

    public init (
        method: HTTPMethod = .get,
        scheme: String? = nil,
        basePath: String? = nil,
        subpath: String,
        query: [String : String] = [:],
        headers: [String : String] = [:]
    ) {
        self.method = method
        self.scheme = scheme
        self.basePath = basePath
        self.subpath = subpath
        self.query = query
        self.headers = headers
    }
}

public extension StandardRequest {
    @discardableResult
    func set (method: HTTPMethod) -> Self {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            query: query,
            headers: headers
        )
    }

    @discardableResult
    func set (scheme: String?) -> Self {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            query: query,
            headers: headers
        )
    }

    @discardableResult
    func set (basePath: String?) -> Self {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            query: query,
            headers: headers
        )
    }

    @discardableResult
    func set (subpath: String) -> Self {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            query: query,
            headers: headers
        )
    }

    @discardableResult
    func set (query: [String: String]) -> Self {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            query: query,
            headers: headers
        )
    }

    @discardableResult
    func set (headers: [String: String]) -> Self {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            query: query,
            headers: headers
        )
    }
}

public extension Request where Self == StandardRequest {
    static func standard (
        method: HTTPMethod = .get,
        scheme: String? = nil,
        basePath: String? = nil,
        subpath: String,
        query: [String : String] = [:],
        headers: [String : String] = [:]
    ) -> StandardRequest {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            query: query,
            headers: headers
        )
    }

    static func get (
        scheme: String? = nil,
        basePath: String? = nil,
        subpath: String,
        query: [String : String] = [:],
        headers: [String : String] = [:]
    ) -> StandardRequest {
        .init(
            method: .get,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            query: query,
            headers: headers
        )
    }

}
