import Foundation

public class DecoratorDelegate <InnerDelegate: RequestDelegate, RequestType: Request, ResponseType: Response, ContentType, ErrorType: Error>: RequestDelegate {
	public let name: String

	public let innerDelegate: InnerDelegate

	let requestHandler: (RequestInfo, InnerDelegate) throws -> RequestType
	let urlSessionHandler: (URLSession, RequestInfo, InnerDelegate) throws -> URLSession
	let urlRequestHandler: (URLRequest, RequestInfo, InnerDelegate) throws -> URLRequest

	let responseHandler: (Data, URLResponse, RequestInfo, InnerDelegate) throws -> ResponseType
	let contentHandler: (ResponseType, RequestInfo, InnerDelegate) throws -> ContentType

	let errorHandler: (ControllerError, RequestInfo, InnerDelegate) -> ErrorType

	public init (
		innerDelegate: InnerDelegate,
        request: @escaping (RequestInfo, InnerDelegate) throws -> RequestType,
        urlSession: @escaping (URLSession, RequestInfo, InnerDelegate) throws -> URLSession = { urlSession, _, _ in urlSession },
        urlRequest: @escaping (URLRequest, RequestInfo, InnerDelegate) throws -> URLRequest = { urlRequest, _, _ in urlRequest },
        response: @escaping (Data, URLResponse, RequestInfo, InnerDelegate) throws -> ResponseType = { data, urlResponse, _, _ in try ResponseType(data, urlResponse) },
        content: @escaping (ResponseType, RequestInfo, InnerDelegate) throws -> ContentType,
        error: @escaping (ControllerError, RequestInfo, InnerDelegate) -> ErrorType,
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
	public func urlSession (_ urlSession: URLSession, _ requestInfo: RequestInfo) throws -> URLSession { try urlSessionHandler(urlSession, requestInfo, innerDelegate) }
	public func urlRequest (_ urlRequest: URLRequest, _ requestInfo: RequestInfo) throws -> URLRequest { try urlRequestHandler(urlRequest, requestInfo, innerDelegate) }

	public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try responseHandler(data, urlResponse, requestInfo, innerDelegate) }
	public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try contentHandler(response, requestInfo, innerDelegate) }

	public func error (_ error: ControllerError, _ requestInfo: RequestInfo) -> ErrorType { errorHandler(error, requestInfo, innerDelegate) }
}
