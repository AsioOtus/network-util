import Foundation

public struct CustomDelegate <RequestType: Request, ResponseType: Response, ContentType, ErrorType: Error> {
    public let name: String

    private let _request: (RequestInfo) throws -> RequestType

	private let _urlSession: (URLSession, RequestInfo) throws -> URLSession
	private let _urlRequest: (URLRequest, RequestInfo) throws -> URLRequest

	private let _response: (Data, URLResponse, RequestInfo) throws -> ResponseType
	private let _content: (ResponseType, RequestInfo) throws -> ContentType

	private let _error: (ControllerError, RequestInfo) -> ErrorType
}

extension CustomDelegate: RequestDelegate {
	public func request (_ requestInfo: RequestInfo) throws -> RequestType { try _request(requestInfo) }

	public func urlSession (_ urlSession: URLSession, _ requestInfo: RequestInfo) throws -> URLSession { try _urlSession(urlSession, requestInfo) }
	public func urlRequest (_ urlRequest: URLRequest, _ requestInfo: RequestInfo) throws -> URLRequest { try _urlRequest(urlRequest, requestInfo) }

	public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try _response(data, urlResponse, requestInfo) }
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try _content(response, requestInfo) }

	public func error (_ error: ControllerError, _ requestInfo: RequestInfo) -> ErrorType { _error(error, requestInfo) }
}

public extension CustomDelegate {
	init (
		request: @escaping (RequestInfo) throws -> RequestType,
		urlSession: @escaping (URLSession, RequestInfo) throws -> URLSession = { urlSession, _ in urlSession },
		urlRequest: @escaping (URLRequest, RequestInfo) throws -> URLRequest = { urlRequest, _ in urlRequest },
		response: @escaping (Data, URLResponse, RequestInfo) throws -> ResponseType = { data, urlResponse, _ in try ResponseType(data, urlResponse) },
		content: @escaping (ResponseType, RequestInfo) throws -> ContentType,
		error: @escaping (ControllerError, RequestInfo) -> ErrorType,
		delegateName: String = "\(RequestType.self)"
	) {
		self.name = delegateName

		self._request = request
		self._urlSession = urlSession
		self._urlRequest = urlRequest
		self._response = response
		self._content = content
		self._error = error
	}
}

public extension CustomDelegate where ResponseType == StandardResponse {
	init (
		request: @escaping (RequestInfo) throws -> RequestType,
		content: @escaping (ResponseType, RequestInfo) throws -> ContentType,
		error: @escaping (ControllerError, RequestInfo) -> ErrorType,
		name: String = "\(RequestType.self)"
	) {
		self.init(
			request: request,
			content: content,
			error: error,
			delegateName: name
		)
	}
}

public extension CustomDelegate where ResponseType == StandardResponse, ErrorType == ControllerError {
	init (
		request: @escaping (RequestInfo) throws -> RequestType,
		content: @escaping (ResponseType, RequestInfo) throws -> ContentType,
		name: String = "\(RequestType.self)"
	) {
		self.init(
			request: request,
			content: content,
			error: { error, _ in error },
			delegateName: name
		)
	}
}

public extension CustomDelegate where ResponseType == ContentType, ResponseType == StandardResponse, ErrorType == ControllerError {
	init (
		request: RequestType,
		name: String = "\(RequestType.self)"
	) {
		self.init(
			request: { _ in request },
			content: { response, _ in response },
			error: { error, _ in error },
			delegateName: name
		)
	}

	init (
		request: @escaping (RequestInfo) throws -> RequestType,
		name: String = "\(RequestType.self)"
	) {
		self.init(
			request: request,
			content: { response, _ in response },
			error: { error, _ in error },
			delegateName: name
		)
	}
}

public extension CustomDelegate {
	@discardableResult
	func on (urlSession urlSessionHandler: @escaping (URLSession, RequestInfo) throws -> URLSession) -> Self {
		.init(
			request: self._request,
			urlSession: urlSessionHandler,
			urlRequest: self._urlRequest,
			response: self._response,
			content: self._content,
			error: 	self._error,
			delegateName: self.name
		)
	}

	@discardableResult
	func on (urlSession urlSessionHandler: @escaping (URLSession) throws -> URLSession) -> Self {
		.init(
			request: self._request,
			urlSession: { urlSession, _ in try urlSessionHandler(urlSession) },
			urlRequest: self._urlRequest,
			response: self._response,
			content: self._content,
			error: 	self._error,
			delegateName: self.name
		)
	}

	@discardableResult
	func on (urlRequest urlRequestHandler: @escaping (URLRequest, RequestInfo) throws -> URLRequest) -> Self {
		.init(
			request: self._request,
			urlSession: self._urlSession,
			urlRequest: urlRequestHandler,
			response: self._response,
			content: self._content,
			error: 	self._error,
			delegateName: self.name
		)
	}

	@discardableResult
	func on (urlRequest urlRequestHandler: @escaping (URLRequest) throws -> URLRequest) -> Self {
		.init(
			request: self._request,
			urlSession: self._urlSession,
			urlRequest: { urlRequest, _ in try urlRequestHandler(urlRequest) },
			response: self._response,
			content: self._content,
			error: 	self._error,
			delegateName: self.name
		)
	}

	@discardableResult
	func on <NewResponseType: Response, NewContentType> (
		response responseHandler: @escaping (Data, URLResponse, RequestInfo) throws -> NewResponseType,
		content contentHandler: @escaping (NewResponseType, RequestInfo) throws -> NewContentType
	) -> CustomDelegate<RequestType, NewResponseType, NewContentType, ErrorType> {
		.init(
			request: self._request,
			urlSession: self._urlSession,
			urlRequest: self._urlRequest,
			response: responseHandler,
			content: contentHandler,
			error: 	self._error,
			delegateName: self.name
		)
	}

	@discardableResult
	func on <NewResponseType: Response, NewContentType> (
		response responseHandler: @escaping (Data, URLResponse) throws -> NewResponseType,
		content contentHandler: @escaping (NewResponseType) throws -> NewContentType
	) -> CustomDelegate<RequestType, NewResponseType, NewContentType, ErrorType> {
		.init(
			request: self._request,
			urlSession: self._urlSession,
			urlRequest: self._urlRequest,
			response: { data, urlResponse, _ in try responseHandler(data, urlResponse) },
			content: { response, _ in try contentHandler(response) },
			error: 	self._error,
			delegateName: self.name
		)
	}

	@discardableResult
	func on <NewContentType> (content contentHandler: @escaping (ResponseType, RequestInfo) throws -> NewContentType) -> CustomDelegate<RequestType, ResponseType, NewContentType, ErrorType> {
		.init(
			request: self._request,
			urlSession: self._urlSession,
			urlRequest: self._urlRequest,
			response: self._response,
			content: contentHandler,
			error: 	self._error,
			delegateName: self.name
		)
	}

	@discardableResult
	func on <NewContentType> (content contentHandler: @escaping (ResponseType) throws -> NewContentType) -> CustomDelegate<RequestType, ResponseType, NewContentType, ErrorType> {
		.init(
			request: self._request,
			urlSession: self._urlSession,
			urlRequest: self._urlRequest,
			response: self._response,
			content: { response, _ in try contentHandler(response) },
			error: 	self._error,
			delegateName: self.name
		)
	}

	@discardableResult
	func on <NewErrorType: Error> (error errorHandler: @escaping (ControllerError, RequestInfo) -> NewErrorType) -> CustomDelegate<RequestType, ResponseType, ContentType, NewErrorType> {
		.init(
			request: self._request,
			urlSession: self._urlSession,
			urlRequest: self._urlRequest,
			response: self._response,
			content: self._content,
			error: 	errorHandler,
			delegateName: self.name
		)
	}

	@discardableResult
	func on <NewErrorType: Error> (error errorHandler: @escaping (ControllerError) -> NewErrorType) -> CustomDelegate<RequestType, ResponseType, ContentType, NewErrorType> {
		.init(
			request: self._request,
			urlSession: self._urlSession,
			urlRequest: self._urlRequest,
			response: self._response,
			content: self._content,
			error: 	{ error, _ in errorHandler(error) },
			delegateName: self.name
		)
	}
}
