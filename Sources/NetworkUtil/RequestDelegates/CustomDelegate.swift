import Foundation

public struct CustomDelegate <RequestType: Request, ResponseType: Response, ContentType, ErrorType: Error>: RequestDelegate {
    public let name: String

    let requestHandler: (RequestInfo) throws -> RequestType

    let urlSessionHandler: (RequestType, RequestInfo) throws -> URLSession
    let urlRequestHandler: (RequestType, RequestInfo) throws -> URLRequest

    let responseHandler: (Data, URLResponse, RequestInfo) throws -> ResponseType
    let contentHandler: (ResponseType, RequestInfo) throws -> ContentType

    let errorHandler: (ControllerError, RequestInfo) -> ErrorType

    init (
        request: @escaping (RequestInfo) throws -> RequestType,
        urlSession: @escaping (RequestType, RequestInfo) throws -> URLSession = { request, _ in try request.urlSession() },
        urlRequest: @escaping (RequestType, RequestInfo) throws -> URLRequest = { request, _ in try request.urlRequest() },
        response: @escaping (Data, URLResponse, RequestInfo) throws -> ResponseType = { data, urlResponse, _ in try ResponseType(data, urlResponse) },
        content: @escaping (ResponseType, RequestInfo) throws -> ContentType,
        error: @escaping (ControllerError, RequestInfo) -> ErrorType,
        name: String = "\(RequestType.self)"
    ) {
        self.name = name

        self.requestHandler = request
        self.urlSessionHandler = urlSession
        self.urlRequestHandler = urlRequest
        self.responseHandler = response
        self.contentHandler = content
        self.errorHandler = error
    }

    public func request (_ requestInfo: RequestInfo) throws -> RequestType { try requestHandler(requestInfo) }

    public func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession { try urlSessionHandler(request, requestInfo) }
    public func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest { try urlRequestHandler(request, requestInfo) }

    public func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try responseHandler(data, urlResponse, requestInfo) }
    public func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType { try contentHandler(response, requestInfo) }

    public func error (_ error: ControllerError, _ requestInfo: RequestInfo) -> ErrorType { errorHandler(error, requestInfo) }
}

public extension CustomDelegate where ResponseType == ContentType, ResponseType == StandardResponse, ErrorType == ControllerError {
    init (
        request: @escaping (RequestInfo) throws -> RequestType,
        urlSession: @escaping (RequestType, RequestInfo) throws -> URLSession = { request, _ in try request.urlSession() },
        urlRequest: @escaping (RequestType, RequestInfo) throws -> URLRequest = { request, _ in try request.urlRequest() },
        response: @escaping (Data, URLResponse, RequestInfo) throws -> ResponseType = { data, urlResponse, _ in try ResponseType(data, urlResponse) },
        content: @escaping (ResponseType, RequestInfo) throws -> ContentType = { response, _ in response },
        requestError: @escaping (ControllerError, RequestInfo) -> ErrorType = { error, _ in error },
        name: String = "\(RequestType.self)"
    ) {
        self.init(
            request: request,
            urlSession: urlSession,
            urlRequest: urlRequest,
            response: response,
            content: content,
            error: requestError,
            name: name
        )
    }
}

public extension CustomDelegate where ErrorType == ControllerError {
    init (
        request: @escaping (RequestInfo) throws -> RequestType,
        urlSession: @escaping (RequestType, RequestInfo) throws -> URLSession = { request, _ in try request.urlSession() },
        urlRequest: @escaping (RequestType, RequestInfo) throws -> URLRequest = { request, _ in try request.urlRequest() },
        response: @escaping (Data, URLResponse, RequestInfo) throws -> ResponseType = { data, urlResponse, _ in try ResponseType(data, urlResponse) },
        content: @escaping (ResponseType, RequestInfo) throws -> ContentType,
        requestError: @escaping (ControllerError, RequestInfo) -> ErrorType = { error, _ in error },
        name: String = "\(RequestType.self)"
    ) {
        self.init(
            request: request,
            urlSession: urlSession,
            urlRequest: urlRequest,
            response: response,
            content: content,
            error: requestError,
            name: name
        )
    }
}
