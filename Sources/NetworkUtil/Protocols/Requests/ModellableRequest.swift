import Foundation

public protocol ModellableRequest: Request {
	associatedtype Model: RequestModel

	var model: Model { get }
}

public protocol RequestModel: Encodable {
	func data () throws -> Data
}

public extension RequestModel {
	func data () throws -> Data { try JSONEncoder().encode(self) }
}
