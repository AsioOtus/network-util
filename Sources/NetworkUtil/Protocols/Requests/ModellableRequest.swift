import Foundation

public protocol ModellableRequest: Request {
	associatedtype Model: RequestModel

	var model: Model { get }
}
