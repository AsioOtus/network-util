import Foundation
import Combine

@available(iOS 13.0, *)
public class StandardNetworkController {
	public let identificationInfo: IdentificationInfo

	private let logger = Logger()
    
    private let urlSessionBuilder: URLSessionBuilder
    private let urlRequestBuilder: URLRequestBuilder

	private var requestInterceptors = [(URLRequest) throws -> URLRequest]()
	private var responseInterceptors = [(URLResponse) throws -> URLResponse]()

	public init (
        urlSessionBuilder: URLSessionBuilder = .standard(),
        urlRequestBuilder: URLRequestBuilder = .default,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
        self.urlSessionBuilder = urlSessionBuilder
        self.urlRequestBuilder = urlRequestBuilder

		self.identificationInfo = IdentificationInfo(
			module: Info.moduleName,
			type: String(describing: Self.self),
			file: file,
			line: line,
			label: label
		)
	}
}

@available(iOS 13.0, *)
extension StandardNetworkController: NetworkController {
    public func send <RQ: Request> (request: RQ, label: String? = nil)
    -> AnyPublisher<StandardResponse, ControllerError>
    {
        send(TransparentDelegate(request: request, response: StandardResponse.self), label: label)
    }

    public func send <RQ: Request, RS: Response> (request: RQ, response: RS.Type, label: String? = nil)
    -> AnyPublisher<RS, ControllerError>
    {
        send(TransparentDelegate(request: request, response: response), label: label)
    }

    public func send <RQ: Request, RM: ResponseModel> (request: RQ, responseModel: RM.Type, label: String? = nil)
    -> AnyPublisher<RM, ControllerError>
    {
        send(TransparentDelegate(request: request, response: StandardModelResponse<RM>.self), label: label)
            .map { response in response.model }
            .eraseToAnyPublisher()
    }

    public func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String? = nil)
    -> AnyPublisher<RD.ContentType, RD.ErrorType>
    {
        let requestInfo = RequestInfo(
            uuid: UUID(),
            label: label,
            delegate: requestDelegate.name,
            controllers: []
        )

        return send(requestDelegate, requestInfo)
    }

	public func send <RD: RequestDelegate> (_ requestDelegate: RD, _ requestInfo: RequestInfo)
    -> AnyPublisher<RD.ContentType, RD.ErrorType>
    {
		let requestInfo = requestInfo
			.add(identificationInfo)

		let requestPublisher = Just(requestDelegate)
            .tryMap { (requestDelegate: RD) -> (RD.RequestType, RD) in
                let request = try requestDelegate.request(requestInfo)
                return (request, requestDelegate)
            }
            .mapError { ControllerError.creationFailure($0) }
            .tryMap { (request: RD.RequestType, requestDelegate: RD) -> (URLSession, URLRequest) in
				var urlSession = try urlSessionBuilder.build(request, requestInfo)
                urlSession = try requestDelegate.urlSession(urlSession, requestInfo)

                var urlRequest = try urlRequestBuilder.build(request, requestInfo)
				urlRequest = try requestDelegate.urlRequest(urlRequest, requestInfo)

				try requestInterceptors.forEach { urlRequest = try $0(urlRequest) }

				self.logger.log(message: .request(urlSession, urlRequest), requestInfo: requestInfo)

				return (urlSession, urlRequest)
			}
            .mapError { ControllerError.requestFailure($0) }
			.flatMap { (urlSession: URLSession, urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), ControllerError> in
				urlSession.dataTaskPublisher(for: urlRequest)
					.mapError {	ControllerError.networkFailure(NetworkError(urlSession, urlRequest, $0)) }
					.eraseToAnyPublisher()
			}
			.tryMap { (data: Data, urlResponse: URLResponse) -> RD.ResponseType in
				var urlResponse = urlResponse

				self.logger.log(message: .response(data, urlResponse), requestInfo: requestInfo)

				try self.responseInterceptors.forEach { urlResponse = try $0(urlResponse) }

				let response = try requestDelegate.response(data, urlResponse, requestInfo)
				return response
			}
            .mapError { ControllerError.responseFailure($0) }
            .tryMap { (response: RD.ResponseType) in
                try requestDelegate.content(response, requestInfo)
            }
            .mapError { ControllerError.contentFailure($0) }
			.handleEvents(
				receiveCompletion: { completion in
					if case .failure(let error) = completion {
						self.logger.log(message: .error(error), requestInfo: requestInfo)
					}
				}
			)

			.mapError { requestDelegate.error($0, requestInfo) }

		return requestPublisher.eraseToAnyPublisher()
	}
}

@available(iOS 13.0, *)
public extension StandardNetworkController {
	@discardableResult
	func loggerSetup (_ logging: (Logger) -> Void) -> Self {
		logging(logger)
		return self
	}

	@discardableResult
	func logging (_ handler: @escaping (LogRecord) -> Void) -> Self {
		logger.logging(handler)
		return self
	}

	@discardableResult
	func add (requestInterceptor: @escaping (URLRequest) throws -> URLRequest) -> Self {
		requestInterceptors.append(requestInterceptor)
		return self
	}

	@discardableResult
	func add (responseInterceptor: @escaping (URLResponse) throws -> URLResponse) -> Self {
		responseInterceptors.append(responseInterceptor)
		return self
	}
}
