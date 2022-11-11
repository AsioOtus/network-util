import Foundation

public protocol ModellableRequest: Request {
	associatedtype Model: RequestModel

	var model: Model { get }
}

public extension ModellableRequest {
	var body: Data? { get throws { try model.data() } }
}
