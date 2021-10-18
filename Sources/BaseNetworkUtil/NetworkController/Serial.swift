import Foundation
import Combine

public struct Serial: NetworkControllerProtocol {
	private let semaphore: DispatchSemaphore
	
	public let controller: NetworkController
	public let source: [String]
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ controller: NetworkController,
		semaphore: DispatchSemaphore? = nil,
		source: [String] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.semaphore = semaphore ?? DispatchSemaphore(value: 1)
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

	public func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String? = nil) -> AnyPublisher<RD.ContentType, NetworkController.Error> {
		let requestInfo = RequestInfo(
			uuid: UUID(),
			label: label,
			source: source,
			controllers: [identificationInfo]
		)
		
		return Just(requestDelegate)
			.wait(for: semaphore)
			.mapError{ .preprocessingFailure($0) }
			.flatMap { controller._send($0, requestInfo).eraseToAnyPublisher() }
			.release(semaphore)
			.mapError{ .postprocessingFailure($0) }
			.eraseToAnyPublisher()
	}
}
