import Foundation
import Combine

public class StandardNetworkController: NetworkController {
	public let identificationInfo: IdentificationInfo
	
	private let logger = Logger()
	
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
            .mapError { RequestError.requestFailure(error: $0) }
            .tryMap { (request: RD.RequestType, requestDelegate: RD) -> (URLSession, URLRequest) in
				let urlSession = try requestDelegate.urlSession(request, requestInfo)
				let urlRequest = try requestDelegate.urlRequest(request, requestInfo)
				
				self.logger.log(message: .request(urlSession, urlRequest), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
				
				return (urlSession, urlRequest)
			}
            .mapError { RequestError.networkFailure(error: $0) }
			.flatMap { (urlSession: URLSession, urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), RequestError> in
				urlSession.dataTaskPublisher(for: urlRequest)
					.mapError {	RequestError.networkFailure(error: NetworkError(urlSession, urlRequest, $0)) }
					.eraseToAnyPublisher()
			}
			.tryMap { (data: Data, urlResponse: URLResponse) -> RD.ResponseType in
				self.logger.log(message: .response(data, urlResponse), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
				
				let response = try requestDelegate.response(data, urlResponse, requestInfo)
				return response
			}
            .mapError { RequestError.networkFailure(error: $0) }
            .tryMap { (response: RD.ResponseType) in
                try requestDelegate.content(response, requestInfo)
            }
            .mapError { RequestError.contentFailure(error: $0) }
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

public extension StandardNetworkController {
	@discardableResult
	func loggerSetup (_ logging: (Logger) -> Void) -> Self {
		logging(logger)
		return self
	}
	
	@discardableResult
	func logging (_ handler: @escaping (Logger.Record) -> Void) -> Self {
		logger.logging(handler)
		return self
	}
}
