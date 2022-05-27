import Foundation

public protocol ModellableRequest: Request {
	associatedtype Model: RequestModel
	
	var model: Model { get }
}

public protocol RequestModel: Encodable {
	init (_ data: Data) throws
}
