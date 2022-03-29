import Foundation

public class WrappingDelegate <InnerDelegate: RequestDelegate, RequestType: Request, ResponseType: Response, ContentType, ErrorType: NetworkUtilError>: RequestDelegate {
	public let name: String
	
	public let innerDelegate: InnerDelegate
	
	var requestHandler: (RequestInfo, InnerDelegate) throws -> RequestType
	
	var urlSessionHandler: (RequestType, RequestInfo, InnerDelegate) throws -> URLSession = { request, _, _ in request.urlSession }
	var urlRequestHandler: (RequestType, RequestInfo, InnerDelegate) throws -> URLRequest = { request, _, _ in request.urlRequest }
	
	var responseHandler: (Data, URLResponse, RequestInfo, InnerDelegate) throws -> ResponseType = { data, urlResponse, _, _ in try ResponseType(data, urlResponse) }
	var contentHandler: (ResponseType, RequestInfo, InnerDelegate) throws -> ContentType
	
	var errorHandler: (NetworkError, RequestInfo, InnerDelegate) -> ErrorType
	
	public init (
		name: String,
		innerDelegate: InnerDelegate,
		request: @escaping (RequestInfo, InnerDelegate) -> RequestType,
		content: @escaping (ResponseType, RequestInfo, InnerDelegate) -> ContentType,
		error: @escaping (NetworkError, RequestInfo, InnerDelegate) -> ErrorType
	) {
		self.name = name
		
		self.innerDelegate = innerDelegate
		
		self.requestHandler = request
		self.contentHandler = content
		self.errorHandler = error
	}
	
	public func request (_ requestInfo: RequestInfo) throws -> RequestType { try requestHandler(requestInfo, innerDelegate) }
	
	public func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession { try urlSessionHandler(request, requestInfo, innerDelegate) }
	public func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest { try urlRequestHandler(request, requestInfo, innerDelegate) }
	
	public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try responseHandler(data, urlResponse, requestInfo, innerDelegate) }
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try contentHandler(response, requestInfo, innerDelegate) }
	
	public func error (_ error: NetworkError, _ requestInfo: RequestInfo) -> ErrorType { errorHandler(error, requestInfo, innerDelegate) }
}

public extension WrappingDelegate where ErrorType == NetworkError {
	convenience init (
		name: String,
		innerDelegate: InnerDelegate,
		request: @escaping (RequestInfo, InnerDelegate) -> RequestType,
		content: @escaping (ResponseType, RequestInfo, InnerDelegate) -> ContentType,
		networkError: @escaping (NetworkError, RequestInfo, InnerDelegate) -> ErrorType = { error, _, _ in error }
	) {
		self.init(name: name, innerDelegate: innerDelegate, request: request, content: content, error: networkError)
	}
}

public extension WrappingDelegate {
	@discardableResult
	func requestHandling (_ requestHandler: @escaping (RequestInfo, InnerDelegate) -> RequestType) -> Self {
		self.requestHandler = requestHandler
		return self
	}
	
	@discardableResult
	func urlSessionHandling (_ urlSessionHandler: @escaping (RequestType, RequestInfo, InnerDelegate) -> URLSession) -> Self {
		self.urlSessionHandler = urlSessionHandler
		return self
	}
	
	@discardableResult
	func urlRequestHandling (_ urlRequestHandler: @escaping (RequestType, RequestInfo, InnerDelegate) -> URLRequest) -> Self {
		self.urlRequestHandler = urlRequestHandler
		return self
	}
	
	@discardableResult
	func responseHandling (_ responseHandler: @escaping (Data, URLResponse, RequestInfo, InnerDelegate) throws -> ResponseType) -> Self {
		self.responseHandler = responseHandler
		return self
	}
	
	@discardableResult
	func contentHandling (_ contentHandler: @escaping (ResponseType, RequestInfo, InnerDelegate) -> ContentType) -> Self {
		self.contentHandler = contentHandler
		return self
	}
	
	@discardableResult
	func errorHandling (_ errorHandler: @escaping (NetworkError, RequestInfo, InnerDelegate) -> ErrorType) -> Self {
		self.errorHandler = errorHandler
		return self
	}
}
