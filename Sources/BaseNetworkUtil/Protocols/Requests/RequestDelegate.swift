import Foundation



public protocol RequestDelegate {
	associatedtype RequestType: Request
	associatedtype ResponseType: Response
	associatedtype ContentType
	
	func request (_ requestInfo: RequestInfo) throws -> RequestType
	
	func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession
	func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest
	
	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType
	func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType
	
	func error (_ error: NetworkController.Error, _ requestInfo: RequestInfo)
}



public extension RequestDelegate {
	func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) -> URLSession { request.urlSession }
	func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) -> URLRequest { request.urlRequest }
	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try ResponseType(data, urlResponse) }
	func error (_ error: NetworkController.Error, _ requestInfo: RequestInfo) { }
}
