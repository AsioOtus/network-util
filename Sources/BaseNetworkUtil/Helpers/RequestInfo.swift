import Foundation

public struct RequestInfo {
	public let uuid: UUID
	public let label: String?
	public let source: [String]
	public let controllers: [IdentificationInfo]
	
	public func add (_ controller: IdentificationInfo) -> Self {
		.init(
			uuid: uuid,
			label: label,
			source: source,
			controllers: self.controllers + [controller]
		)
	}
	
	public func add (_ source: [String]) -> Self {
		.init(
			uuid: uuid,
			label: label,
			source: source + self.source,
			controllers: controllers
		)
	}
}
