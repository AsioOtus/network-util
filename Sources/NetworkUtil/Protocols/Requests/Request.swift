import Foundation

public protocol Request <Body>: CustomStringConvertible {
	associatedtype Body: Encodable = Data

	var method: HTTPMethod { get }
	
	var path: String { get }

	var query: Query { get }
	var headers: Headers { get }

	var body: Body? { get }

	func configurationUpdate (_ configuration: URLRequestConfiguration) -> URLRequestConfiguration
	func interception (_ urlRequest: URLRequest) async throws -> URLRequest
}

public extension Request {
	var description: String { "\(Self.self)" }

	var method: HTTPMethod { .get }

	var query: Query { [:] }
	var headers: Headers { [:] }

	func configurationUpdate (_ configuration: URLRequestConfiguration) -> URLRequestConfiguration { configuration }
	func interception (_ urlRequest: URLRequest) async throws -> URLRequest { urlRequest }
}
