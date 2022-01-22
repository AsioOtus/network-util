import Foundation
import Combine

extension Serial {
	public struct Error <RD: RequestDelegate>: BaseNetworkUtilError {
		let requestDelegate: RD
		let innerError: Swift.Error
	}
}

public struct Serial: NetworkControllerProtocol {
	private let semaphore: DispatchSemaphore
	
	public let controller: NetworkControllerProtocol
	public let source: [String]
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ controller: NetworkControllerProtocol,
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

	public func send <RD: RequestDelegate> (_ requestDelegate: RD, source: [String] = [], label: String? = nil) -> AnyPublisher<RD.ContentType, NetworkController.Error> {
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
	
	public func send<RD>(_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, NetworkController.Error> where RD : RequestDelegate {
		return Just(requestDelegate)
			.wait(for: semaphore)
			.mapError{ .preprocessingFailure(Error(requestDelegate: requestDelegate, innerError: $0)) }
			.flatMap { controller.send($0, requestInfo).eraseToAnyPublisher() }
			.signal(semaphore)
			.eraseToAnyPublisher()
	}
}

public extension NetworkControllerProtocol {
	func serial (
		source: [String] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Serial {
		.init(self, source: source, label: label, file: file, line: line)
	}
}
