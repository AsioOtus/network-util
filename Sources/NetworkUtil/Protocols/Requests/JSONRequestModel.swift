import Foundation

public protocol JSONRequest: Request {
	associatedtype Model: Encodable

	var model: Model { get }
}

public extension JSONRequest {
	func data () throws -> Data { try JSONEncoder().encode(model) }
}
