import Foundation

public protocol Request <Body>: CustomStringConvertible {
	associatedtype Body: Encodable = Data

	var method: HTTPMethod { get }

	var path: String { get }

	var query: [String: String] { get }
	var headers: [String: String] { get }

	var body: Body? { get throws }

	func interception (_ urlRequest: URLRequest) throws -> URLRequest
}

public extension Request {
	var description: String { "\(Self.self)" }

	var method: HTTPMethod { .get }

	var query: [String: String] { [:] }
	var headers: [String: String] { [:] }

	var body: Body? { nil }

	func interception (_ urlRequest: URLRequest) throws -> URLRequest { urlRequest }
}
