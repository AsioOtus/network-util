import Foundation

public struct DebugDelegate <RequestType: Request, ResponseType: Response, ContentType, ErrorType>: RequestDelegate {
	public let name: String
	
	public let requestValue: RequestType
	public let urlSessionValue: URLSession?
	public let urlRequestValue: URLRequest?
	public let responseValue: ResponseType?
	public let contentValue: ContentType?
	public let errorValue: ErrorType?
	
	let contentHandler: (ResponseType, RequestInfo) throws -> ContentType
	let errorHandler: (NetworkError, RequestInfo) -> ErrorType
	
	public init (
		name: String = "\(RequestType.self)",
		requestValue: RequestType,
		urlSessionValue: URLSession? = nil,
		urlRequestValue: URLRequest? = nil,
		responseValue: ResponseType? = nil,
		contentValue: ContentType? = nil,
		errorValue: ErrorType? = nil,
		contentHandler: @escaping (ResponseType, RequestInfo) throws -> ContentType,
		errorHandler: @escaping (NetworkError, RequestInfo) -> ErrorType
	) {
		self.name = name
		self.requestValue = requestValue
		
		self.urlSessionValue = urlSessionValue
		self.urlRequestValue = urlRequestValue
		
		self.responseValue = responseValue
		self.contentValue = contentValue
		self.errorValue = errorValue
		
		self.contentHandler = contentHandler
		self.errorHandler = errorHandler
	}
	
	public func request (_ requestInfo: RequestInfo) throws -> RequestType { requestValue }
	
	public func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession { try urlSessionValue ?? request.urlSession() }
	public func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest { try urlRequestValue ?? request.urlRequest() }
	
	public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try responseValue ?? ResponseType(data, urlResponse) }
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try contentValue ?? contentHandler(response, requestInfo) }
	
	public func error (_ error: NetworkError, _ requestInfo: RequestInfo) -> ErrorType { errorValue ?? errorHandler(error, requestInfo) }
}

public extension DebugDelegate where ErrorType == NetworkError {
	init (
		name: String = "\(RequestType.self)",
		requestValue: RequestType,
		urlSessionValue: URLSession? = nil,
		urlRequestValue: URLRequest? = nil,
		responseValue: ResponseType? = nil,
		contentValue: ContentType? = nil,
		errorValue: ErrorType? = nil,
		contentHandler: @escaping (ResponseType, RequestInfo) throws -> ContentType,
		networkErrorHandler: @escaping (NetworkError, RequestInfo) -> ErrorType = { error, _ in error }
	) {
		self.init(
			name: name,
			requestValue: requestValue,
			urlSessionValue: urlSessionValue,
			urlRequestValue: urlRequestValue,
			responseValue: responseValue,
			contentValue: contentValue,
			errorValue: errorValue,
			contentHandler: contentHandler,
			errorHandler: networkErrorHandler
		)
	}
}
