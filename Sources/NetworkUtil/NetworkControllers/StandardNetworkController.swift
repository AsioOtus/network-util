import Foundation
import Combine

@available(iOS 13.0, *)
public class StandardNetworkController: NetworkController {
	public let identificationInfo: IdentificationInfo

	private let logger = Logger()

	private var interceptors = [(URLRequest) throws -> URLRequest]()

	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
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
public extension StandardNetworkController {
	func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String? = nil) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = RequestInfo(
			uuid: UUID(),
			label: label,
			delegate: requestDelegate.name,
			controllers: []
		)

		return send(requestDelegate, requestInfo)
	}

	func send <RD: RequestDelegate> (_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = requestInfo
			.add(identificationInfo)

		let requestPublisher = Just(requestDelegate)
            .tryMap { (requestDelegate: RD) -> (RD.RequestType, RD) in
                let request = try requestDelegate.request(requestInfo)
                return (request, requestDelegate)
            }
            .mapError { RequestError.creationFailure($0) }
            .tryMap { (request: RD.RequestType, requestDelegate: RD) -> (URLSession, URLRequest) in
				let urlSession = try requestDelegate.urlSession(request, requestInfo)
				var urlRequest = try requestDelegate.urlRequest(request, requestInfo)

				try interceptors.forEach { urlRequest = try $0(urlRequest) }

				self.logger.log(message: .request(urlSession, urlRequest), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)

				return (urlSession, urlRequest)
			}
            .mapError { RequestError.requestFailure($0) }
			.flatMap { (urlSession: URLSession, urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), RequestError> in
				urlSession.dataTaskPublisher(for: urlRequest)
					.mapError {	RequestError.networkFailure(NetworkError(urlSession, urlRequest, $0)) }
					.eraseToAnyPublisher()
			}
			.tryMap { (data: Data, urlResponse: URLResponse) -> RD.ResponseType in
				self.logger.log(message: .response(data, urlResponse), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)

				let response = try requestDelegate.response(data, urlResponse, requestInfo)
				return response
			}
            .mapError { RequestError.responseFailure($0) }
            .tryMap { (response: RD.ResponseType) in
                try requestDelegate.content(response, requestInfo)
            }
            .mapError { RequestError.contentFailure($0) }
			.handleEvents(
				receiveCompletion: { completion in
					if case .failure(let error) = completion {
						self.logger.log(message: .error(error), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
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
	func add (interseptor: @escaping (URLRequest) throws -> URLRequest) -> Self {
		interceptors.append(interseptor)
		return self
	}
}
