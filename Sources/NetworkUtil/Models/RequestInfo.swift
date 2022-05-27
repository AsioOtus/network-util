import Foundation

public struct RequestInfo {
	public let uuid: UUID
	public let label: String?
	public let delegate: String
	public let controllers: [IdentificationInfo]
	
	public func add (_ controller: IdentificationInfo) -> Self {
		.init(
			uuid: uuid,
			label: label,
			delegate: delegate,
			controllers: self.controllers + [controller]
		)
	}
}
