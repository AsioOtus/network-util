public struct StandardModelRequest <Model: RequestModel>: StructuredModellableRequest {
    public let method: HTTPMethod

    public let scheme: String?
    public let basePath: String?
    public let subpath: String

    public let model: Model

    public let query: [String: String]
    public let headers: [String: String]

    public init (
        method: HTTPMethod = .post,
        scheme: String? = nil,
        basePath: String? = nil,
        subpath: String,
        model: Model,
        query: [String : String] = [:],
        headers: [String : String] = [:]
    ) {
        self.method = method
        self.scheme = scheme
        self.basePath = basePath
        self.subpath = subpath
        self.model = model
        self.query = query
        self.headers = headers
    }
}

public extension StandardModelRequest {
    @discardableResult
    func set (method: HTTPMethod) -> Self {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            model: model,
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
            model: model,
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
            model: model,
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
            model: model,
            query: query,
            headers: headers
        )
    }

    @discardableResult
    func set <NewModel: RequestModel> (model: NewModel) -> StandardModelRequest<NewModel> {
        .init(
            method: method,
            scheme: scheme,
            basePath: basePath,
            subpath: subpath,
            model: model,
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
            model: model,
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
            model: model,
            query: query,
            headers: headers
        )
    }
}
