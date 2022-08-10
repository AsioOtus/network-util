import Foundation

public struct AnyRequestDelegate <RequestType: Request, ResponseType: Response, ContentType, ErrorType: Error>: RequestDelegate {
	public let name: String

	private let requestHandler: (RequestInfo) throws -> RequestType
	private let urlSessionHandler: (URLSession, RequestInfo) throws -> URLSession
	private let urlRequestHandler: (URLRequest, RequestInfo) throws -> URLRequest

	private let responseHandler: (Data, URLResponse, RequestInfo) throws -> ResponseType
	private let contentHandler: (ResponseType, RequestInfo) throws -> ContentType

	private let errorHandler: (ControllerError, RequestInfo) -> ErrorType

	public init <RD: RequestDelegate> (
		_ delegate: RD,
		name: String = "\(RequestType.self)"
	)
	where
	RequestType == RD.RequestType,
	ResponseType == RD.ResponseType,
	ContentType == RD.ContentType,
	ErrorType == RD.ErrorType
	{
		self.name = name

		self.requestHandler = { try delegate.request($0) }
		self.urlSessionHandler = { try delegate.urlSession($0, $1) }
		self.urlRequestHandler = { try delegate.urlRequest($0, $1) }
		self.responseHandler = { try delegate.response($0, $1, $2) }
		self.contentHandler = { try delegate.content($0, $1) }
		self.errorHandler = { delegate.error($0, $1) }
	}

	public func request (_ requestInfo: RequestInfo) throws -> RequestType { try requestHandler(requestInfo) }
	public func urlSession (_ urlSession: URLSession, _ requestInfo: RequestInfo) throws -> URLSession { try urlSessionHandler(urlSession, requestInfo) }
	public func urlRequest (_ urlRequest: URLRequest, _ requestInfo: RequestInfo) throws -> URLRequest { try urlRequestHandler(urlRequest, requestInfo) }

	public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try responseHandler(data, urlResponse, requestInfo) }
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try contentHandler(response, requestInfo) }

	public func error (_ error: ControllerError, _ requestInfo: RequestInfo) -> ErrorType { errorHandler(error, requestInfo) }
}


public extension RequestDelegate {
	func eraseToAnyRequestDelegate () -> AnyRequestDelegate<RequestType, ResponseType, ContentType, ErrorType> {
		.init(self)
	}
}
