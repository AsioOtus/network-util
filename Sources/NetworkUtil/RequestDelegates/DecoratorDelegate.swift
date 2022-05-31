import Foundation

public class DecoratorDelegate <InnerDelegate: RequestDelegate, RequestType: Request, ResponseType: Response, ContentType, ErrorType: Error>: RequestDelegate {
	public let name: String
	
	public let innerDelegate: InnerDelegate
	
	let requestHandler: (RequestInfo, InnerDelegate) throws -> RequestType
	let urlSessionHandler: (RequestType, RequestInfo, InnerDelegate) throws -> URLSession
	let urlRequestHandler: (RequestType, RequestInfo, InnerDelegate) throws -> URLRequest
	
	let responseHandler: (Data, URLResponse, RequestInfo, InnerDelegate) throws -> ResponseType
	let contentHandler: (ResponseType, RequestInfo, InnerDelegate) throws -> ContentType
	
	let errorHandler: (RequestError, RequestInfo, InnerDelegate) -> ErrorType
	
	public init (
		innerDelegate: InnerDelegate,
        request: @escaping (RequestInfo, InnerDelegate) throws -> RequestType,
        urlSession: @escaping (RequestType, RequestInfo, InnerDelegate) throws -> URLSession = { request, _, _ in try request.urlSession() },
        urlRequest: @escaping (RequestType, RequestInfo, InnerDelegate) throws -> URLRequest = { request, _, _ in try request.urlRequest() },
        response: @escaping (Data, URLResponse, RequestInfo, InnerDelegate) throws -> ResponseType = { data, urlResponse, _, _ in try ResponseType(data, urlResponse) },
        content: @escaping (ResponseType, RequestInfo, InnerDelegate) throws -> ContentType,
        error: @escaping (RequestError, RequestInfo, InnerDelegate) -> ErrorType,
        name: String = "\(RequestType.self)"
	) {
		self.name = name
		
		self.innerDelegate = innerDelegate
		
        self.requestHandler = request
        self.urlSessionHandler = urlSession
        self.urlRequestHandler = urlRequest
        self.responseHandler = response
        self.contentHandler = content
        self.errorHandler = error
	}
	
	public func request (_ requestInfo: RequestInfo) throws -> RequestType { try requestHandler(requestInfo, innerDelegate) }
	public func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession { try urlSessionHandler(request, requestInfo, innerDelegate) }
	public func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest { try urlRequestHandler(request, requestInfo, innerDelegate) }
	
	public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try responseHandler(data, urlResponse, requestInfo, innerDelegate) }
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try contentHandler(response, requestInfo, innerDelegate) }
	
	public func error (_ error: RequestError, _ requestInfo: RequestInfo) -> ErrorType { errorHandler(error, requestInfo, innerDelegate) }
}
