import Foundation

public struct StandardURLSessionBuilder {
	public let urlSession: URLSession

	public init (_ urlSession: URLSession = .init(configuration: .default)) {
		self.urlSession = urlSession
	}
}

extension StandardURLSessionBuilder: URLSessionBuilder {
	public func build (_ request: some Request) throws -> URLSession {
		urlSession
	}
}

public extension URLSessionBuilder where Self == StandardURLSessionBuilder {
	static func standard (_ urlSession: URLSession = .init(configuration: .default)) -> Self {
		.init(urlSession)
	}
}
