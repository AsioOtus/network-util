import Foundation

public struct TransparentDelegate <RequestType: Request, ResponseType: Response>: RequestDelegate {
	public let name: String
	
	public let requestValue: RequestType
	public let urlSessionValue: URLSession?
	public let urlRequestValue: URLRequest?
	
	public init (
		name: String = "\(RequestType.self)",
		request: RequestType,
		urlSession: URLSession? = nil,
		urlRequest: URLRequest? = nil,
		responseType: ResponseType.Type
	) {
		self.name = name
		self.requestValue = request
		
		self.urlSessionValue = urlSession
		self.urlRequestValue = urlRequest
	}
	
	public func request (_ requestInfo: RequestInfo) throws -> RequestType { requestValue }
	
	public func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession { try urlSessionValue ?? request.urlSession() }
	public func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest { try urlRequestValue ?? request.urlRequest() }
	
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ResponseType { response }
	public func error(_ error: NetworkError, _ requestInfo: RequestInfo) -> NetworkError { error }
}

public extension TransparentDelegate where ResponseType == StandardResponse {
	init (
		name: String = "\(RequestType.self)",
		request: RequestType,
		urlSession: URLSession? = nil,
		urlRequest: URLRequest? = nil
	) {
		self.name = name
		self.requestValue = request
		
		self.urlSessionValue = urlSession
		self.urlRequestValue = urlRequest
	}
}
