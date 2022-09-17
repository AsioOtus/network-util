import Foundation

public struct AnyRequestDelegate <RequestType: Request, ResponseType: Response, ContentType, ErrorType: Error>: RequestDelegate {
	public let name: String

	private let _request: (RequestInfo) throws -> RequestType
	private let _urlSession: (URLSession, RequestInfo) throws -> URLSession
	private let _urlRequest: (URLRequest, RequestInfo) throws -> URLRequest

	private let _response: (Data, URLResponse, RequestInfo) throws -> ResponseType
	private let _content: (ResponseType, RequestInfo) throws -> ContentType

	private let _error: (ControllerError.Category, RequestInfo) -> ErrorType

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

		self._request = { try delegate.request($0) }
		self._urlSession = { try delegate.urlSession($0, $1) }
		self._urlRequest = { try delegate.urlRequest($0, $1) }
		self._response = { try delegate.response($0, $1, $2) }
		self._content = { try delegate.content($0, $1) }
		self._error = { delegate.error($0, $1) }
	}

	public func request (_ requestInfo: RequestInfo) throws -> RequestType { try _request(requestInfo) }
	public func urlSession (_ urlSession: URLSession, _ requestInfo: RequestInfo) throws -> URLSession { try _urlSession(urlSession, requestInfo) }
	public func urlRequest (_ urlRequest: URLRequest, _ requestInfo: RequestInfo) throws -> URLRequest { try _urlRequest(urlRequest, requestInfo) }

	public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try _response(data, urlResponse, requestInfo) }
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try _content(response, requestInfo) }

	public func error (_ error: ControllerError, _ requestInfo: RequestInfo) -> ErrorType { _error(error, requestInfo) }
}


public extension RequestDelegate {
	func eraseToAnyRequestDelegate () -> AnyRequestDelegate<RequestType, ResponseType, ContentType, ErrorType> {
		.init(self)
	}
}
