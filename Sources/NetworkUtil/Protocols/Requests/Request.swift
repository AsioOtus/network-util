import Foundation

public protocol Request: CustomStringConvertible {
	var method: HTTPMethod { get }

	var path: String { get }

	var query: [String: String] { get }
	var headers: [String: String] { get }

	var body: Data? { get throws }
}

public extension Request {
	var description: String { "\(Self.self)" }

	var method: HTTPMethod { .get }

	var query: [String: String] { [:] }
	var headers: [String: String] { [:] }

	var body: Data? { get throws { nil } }
}
