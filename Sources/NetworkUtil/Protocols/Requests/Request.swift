import Foundation

public protocol Request {
	func urlSession () throws -> URLSession?
	func urlRequest () throws -> URLRequest
}

public extension Request {
	func urlSession () -> URLSession? { nil }
}
