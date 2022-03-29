import Foundation
import Combine

public class StandardNetworkController: NetworkController {
	public let source: [String]
	public let identificationInfo: IdentificationInfo
	
	private let logger = Logger()
	
	public init (
		source: [String] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.source = source
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
	func send <RD: RequestDelegate> (_ requestDelegate: RD, source: [String] = [], label: String? = nil) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = RequestInfo(
			uuid: UUID(),
			label: label,
			delegate: requestDelegate.name,
			source: source,
			controllers: []
		)
		
		return send(requestDelegate, requestInfo)
	}
	
	func send <RD: RequestDelegate> (_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = requestInfo
			.add(identificationInfo)
			.add(source)
		
		let requestPublisher = Just(requestDelegate)
			.tryMap { (requestDelegate: RD) -> (URLSession, URLRequest) in
				let request = try requestDelegate.request(requestInfo)
				let urlSession = try requestDelegate.urlSession(request, requestInfo)
				let urlRequest = try requestDelegate.urlRequest(request, requestInfo)
				
				self.logger.log(message: .request(urlSession, urlRequest), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
				
				return (urlSession, urlRequest)
			}
			.mapError { NetworkError.preprocessing(error: $0) }
			.flatMap { (urlSession: URLSession, urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), NetworkError> in
				urlSession.dataTaskPublisher(for: urlRequest)
					.mapError {	NetworkError.networkFailure(urlSession, urlRequest, $0) }
					.eraseToAnyPublisher()
			}
			.tryMap { (data: Data, urlResponse: URLResponse) -> RD.ContentType in
				self.logger.log(message: .response(data, urlResponse), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
				
				let response = try requestDelegate.response(data, urlResponse, requestInfo)
				let content = try requestDelegate.content(response, requestInfo)
				
				return content
			}
			.mapError { NetworkError.postprocessing(error: $0) }
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
	func loggerSetup (_ logging: (Logger) -> Void) -> StandardNetworkController {
		logging(logger)
		return self
	}
	
	@discardableResult
	func logging (_ handler: @escaping (Logger.Record) -> Void) -> StandardNetworkController {
		logger.logging(handler)
		return self
	}
}
