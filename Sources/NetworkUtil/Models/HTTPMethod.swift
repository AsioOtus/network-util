public struct HTTPMethod {
    public let stringValue: String

    public init (_ stringValue: String) {
        self.stringValue = stringValue.uppercased()
    }
}

extension HTTPMethod: ExpressibleByStringLiteral {
    public init (stringLiteral: String) {
        self.init(stringLiteral)
    }
}

public extension HTTPMethod {
    static let get = Self("get")
    static let head = Self("head")
    static let post = Self("post")
    static let put = Self("put")
    static let delete = Self("delete")
    static let connect = Self("connect")
    static let option = Self("option")
    static let trace = Self("trace")
    static let patch = Self("patch")
}

public extension String {
    var asHttpMethod: HTTPMethod { .init(self) }
}
