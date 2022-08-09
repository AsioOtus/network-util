import Foundation

public protocol StructuredModellableRequest: StructuredRequest, ModellableRequest { }

public extension StructuredModellableRequest {
	var body: Data? { get throws { try model.data() } }
}
