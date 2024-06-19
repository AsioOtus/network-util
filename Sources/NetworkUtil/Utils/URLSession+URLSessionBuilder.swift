import Foundation

extension URLSession: URLSessionBuilder {
	public func build(_ request: some Request) throws -> URLSession {
		self
	}
}
