import Foundation

public protocol Request <Body>: CustomStringConvertible {
	associatedtype Body: Encodable = Data

	var method: HTTPMethod { get }

	var path: String { get }

	var query: Query { get }
	var headers: Headers { get }

	var body: Body? { get }

	func interception (_ urlRequest: URLRequest) throws -> URLRequest
}

public extension Request {
	var description: String { "\(Self.self)" }

	var method: HTTPMethod { .get }

	var query: Query { [:] }
	var headers: Headers { [:] }

	func interception (_ urlRequest: URLRequest) throws -> URLRequest { urlRequest }
}
