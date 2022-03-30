import Foundation
import Combine

public typealias Serial = SerialDecorator

public class SerialDecorator: NetworkController {
	private let semaphore: DispatchSemaphore
	
	public let controller: NetworkController
	public let source: [String]
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ controller: NetworkController,
		source: [String] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.semaphore = DispatchSemaphore(value: 1)
		self.controller = controller
		self.source = source
		self.identificationInfo = IdentificationInfo(
			module: Info.moduleName,
			type: String(describing: Self.self),
			file: file,
			line: line,
			label: label
		)
	}

	public func send <RD: RequestDelegate> (_ requestDelegate: RD, source: [String] = [], label: String? = nil) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = RequestInfo(
			uuid: UUID(),
			label: label,
			delegate: requestDelegate.name,
			source: source,
			controllers: [identificationInfo]
		)
		.add(source)
		
		return send(requestDelegate, requestInfo)
	}
	
	public func send <RD: RequestDelegate>(_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		return Just(requestDelegate)
			.wait(for: semaphore)
			.mapError{ requestDelegate.error(NetworkError.preprocessing(error: $0), requestInfo) }
            .flatMap { self.controller.send($0, requestInfo).eraseToAnyPublisher() }
			.signal(semaphore)
			.mapError{ requestDelegate.error(NetworkError.postprocessing(error: $0), requestInfo) }
			.eraseToAnyPublisher()
	}
}

public extension NetworkController {
	func serial (
		source: [String] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Serial {
		.init(self, source: source, label: label, file: file, line: line)
	}
}
