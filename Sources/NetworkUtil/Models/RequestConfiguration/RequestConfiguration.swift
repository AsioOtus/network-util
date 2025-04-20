import Foundation

public struct RequestConfiguration: Hashable {
	public let method: Method?
	public let urlComponents: URLComponents
	public let headers: Headers
	public let timeout: Double?
    public let cachePolicy: URLRequest.CachePolicy?
	public let info: Info

	public init (
		method: Method? = nil,
		urlComponents: URLComponents = .init(),
		headers: Headers = [:],
		timeout: Double? = nil,
        cachePolicy: URLRequest.CachePolicy? = nil,
		info: Info = [:]
	) {
		self.method = method
		self.urlComponents = urlComponents
		self.headers = headers
		self.timeout = timeout
        self.cachePolicy = cachePolicy
		self.info = info
	}
}

public extension RequestConfiguration {
	static let empty = Self()
}

public extension RequestConfiguration {
	func merge (with another: Self) -> Self {
		.init(
			method: self.method ?? another.method,
			urlComponents: self.urlComponents.merge(with: another.urlComponents),
			headers: another.headers.merging(self.headers) { $1 },
			timeout: self.timeout ?? another.timeout,
            cachePolicy: self.cachePolicy ?? another.cachePolicy,
			info: another.info.merging(self.info) { $1 }
		)
	}
}
