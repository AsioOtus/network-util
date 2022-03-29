import Foundation

public class GeneralDelegate <RequestType: Request, ResponseType: Response, ContentType, ErrorType: NetworkUtilError>: RequestDelegate {
	public let name: String
	
	var requestHandler: (RequestInfo) throws -> RequestType
	
	var urlSessionHandler: (RequestType, RequestInfo) throws -> URLSession = { request, _ in request.urlSession }
	var urlRequestHandler: (RequestType, RequestInfo) throws -> URLRequest = { request, _ in request.urlRequest }
	
	var responseHandler: (Data, URLResponse, RequestInfo) throws -> ResponseType = { data, urlResponse, _ in try ResponseType(data, urlResponse) }
	var contentHandler: (ResponseType, RequestInfo) throws -> ContentType
	
	var errorHandler: (NetworkError, RequestInfo) -> ErrorType
	
	public init (
		name: String,
		request: @escaping (RequestInfo) -> RequestType,
		content: @escaping (ResponseType, RequestInfo) -> ContentType,
		error: @escaping (NetworkError, RequestInfo) -> ErrorType
	) {
		self.name = name
		
		self.requestHandler = request
		self.contentHandler = content
		self.errorHandler = error
	}
	
	public func request (_ requestInfo: RequestInfo) throws -> RequestType { try requestHandler(requestInfo) }
	
	public func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession { try urlSessionHandler(request, requestInfo) }
	public func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest { try urlRequestHandler(request, requestInfo) }
	
	public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try responseHandler(data, urlResponse, requestInfo) }
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try contentHandler(response, requestInfo) }
	
	public func error (_ error: NetworkError, _ requestInfo: RequestInfo) -> ErrorType { errorHandler(error, requestInfo) }
}

public extension GeneralDelegate where ErrorType == NetworkError {
	convenience init (
		name: String,
		request: @escaping (RequestInfo) -> RequestType,
		content: @escaping (ResponseType, RequestInfo) -> ContentType,
		networkError: @escaping (NetworkError, RequestInfo) -> ErrorType = { error, _ in error }
	) {
		self.init(name: name, request: request, content: content, error: networkError)
	}
}

public extension GeneralDelegate {
	@discardableResult
	func requestHandling (_ requestHandler: @escaping (RequestInfo) -> RequestType) -> Self {
		self.requestHandler = requestHandler
		return self
	}
	
	@discardableResult
	func urlSessionHandling (_ urlSessionHandler: @escaping (RequestType, RequestInfo) -> URLSession) -> Self {
		self.urlSessionHandler = urlSessionHandler
		return self
	}
	
	@discardableResult
	func urlRequestHandling (_ urlRequestHandler: @escaping (RequestType, RequestInfo) -> URLRequest) -> Self {
		self.urlRequestHandler = urlRequestHandler
		return self
	}
	
	@discardableResult
	func responseHandling (_ responseHandler: @escaping (Data, URLResponse, RequestInfo) throws -> ResponseType) -> Self {
		self.responseHandler = responseHandler
		return self
	}
	
	@discardableResult
	func contentHandling (_ contentHandler: @escaping (ResponseType, RequestInfo) -> ContentType) -> Self {
		self.contentHandler = contentHandler
		return self
	}
	
	@discardableResult
	func errorHandling (_ errorHandler: @escaping (NetworkError, RequestInfo) -> ErrorType) -> Self {
		self.errorHandler = errorHandler
		return self
	}
}
