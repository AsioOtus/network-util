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
            .tryMap { (requestDelegate: RD) -> RD.RequestType in
				try requestDelegate.request(requestInfo)
			}
			.tryMap { (request: RD.RequestType) -> (URLSession, URLRequest) in
				try (requestDelegate.urlSession(request, requestInfo), requestDelegate.urlRequest(request, requestInfo))
			}
            .mapError { NetworkError.preprocessing(error: $0) }
            .handleEvents(receiveOutput: { (urlSession: URLSession, urlRequest: URLRequest) in
                self.logger.log(message: .request(urlSession, urlRequest), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
            })
        
			.flatMap { (urlSession: URLSession, urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), NetworkError> in
				urlSession.dataTaskPublisher(for: urlRequest)
					.mapError {	NetworkError.networkFailure(urlSession, urlRequest, $0) }
					.eraseToAnyPublisher()
			}
            .handleEvents(receiveOutput: { (data: Data, urlResponse: URLResponse) in
                self.logger.log(message: .response(data, urlResponse), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
            })
        
			.tryMap { (data: Data, urlResponse: URLResponse) -> RD.ResponseType in
				try requestDelegate.response(data, urlResponse, requestInfo)
			}
			.tryMap { (response: RD.ResponseType) -> RD.ContentType in
				try requestDelegate.content(response, requestInfo)
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
