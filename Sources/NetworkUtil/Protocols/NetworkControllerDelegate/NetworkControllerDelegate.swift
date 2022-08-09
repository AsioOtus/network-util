import Foundation

public protocol NetworkControllerDelegate {
	func urlSession <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLSession
	func urlRequest <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLRequest
}

public extension NetworkControllerDelegate {
	func urlSession <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLSession {
		try request.urlSession()
	}

	func urlRequest <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLRequest {
		try request.urlRequest()
	}
}
