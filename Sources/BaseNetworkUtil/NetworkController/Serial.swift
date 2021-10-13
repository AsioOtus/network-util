import Foundation
import Combine

public struct Serial: NetworkControllerProtocol {
	private let semaphore = DispatchSemaphore(value: 1)
	
	public let controller: NetworkController
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ controller: NetworkController,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.controller = controller
		self.identificationInfo = IdentificationInfo(Info.moduleName, type: String(describing: Self.self), file: file, line: line, label: label)
	}

	public func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String? = nil) -> AnyPublisher<RD.ContentType, NetworkController.Error> {
		let requestInfo = NetworkController.RequestInfo(controllersIdentificationInfo: [identificationInfo], source: ["Serial"], requestUuid: UUID(), sendingLabel: label)
		
		return Just(requestDelegate)
			.wait(for: semaphore)
			.mapError{ .preprocessingFailure($0) }
			.flatMap { controller._send($0, requestInfo, label).eraseToAnyPublisher() }
			.release(semaphore)
			.mapError{ .postprocessingFailure($0) }
			.eraseToAnyPublisher()
	}
}
