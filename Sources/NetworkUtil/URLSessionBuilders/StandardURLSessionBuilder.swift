import Foundation

public struct StandardURLSessionBuilder {
    public static let standard = Self()

    public let urlSession: URLSession

    public init (_ urlSession: URLSession = .init(configuration: .default)) {
        self.urlSession = urlSession
    }
}

extension StandardURLSessionBuilder: URLSessionBuilder {
    public func build <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLSession {
        try request.urlSession() ?? urlSession
    }
}

public extension URLSessionBuilder where Self == StandardURLSessionBuilder {
    static func standard (_ urlSession: URLSession = .init(configuration: .default)) -> StandardURLSessionBuilder {
        .init(urlSession)
    }
}
