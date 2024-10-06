import Foundation

extension URLSession: URLSessionBuilder {
	public func build (configuration: RequestConfiguration) throws -> URLSession {
		self
	}
}
