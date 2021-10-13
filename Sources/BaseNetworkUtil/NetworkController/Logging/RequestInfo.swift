import Foundation

extension NetworkController {
	public struct RequestInfo {
		public let controllersIdentificationInfo: [IdentificationInfo]
		public let source: [String]
		public let requestUuid: UUID
		public let sendingLabel: String?
		
		public func add (_ controllerIdentificationInfo: IdentificationInfo) -> Self {
			.init(
				controllersIdentificationInfo: self.controllersIdentificationInfo + [controllerIdentificationInfo],
				source: source,
				requestUuid: requestUuid,
				sendingLabel: sendingLabel
			)
		}
		
		public func add (_ source: [String]) -> Self {
			.init(
				controllersIdentificationInfo: controllersIdentificationInfo,
				source: source + self.source,
				requestUuid: requestUuid,
				sendingLabel: sendingLabel
			)
		}
	}
}
