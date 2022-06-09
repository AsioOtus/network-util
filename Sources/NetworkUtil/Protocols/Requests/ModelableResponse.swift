import Foundation

public protocol ModellableResponse: Response {
	associatedtype Model: ResponseModel

	var model: Model { get }
}

public protocol ResponseModel: Decodable {
	init (_ data: Data) throws
}

public extension ResponseModel {
	init (_ data: Data) throws {
		self = try JSONDecoder().decode(Self.self, from: data)
	}
}
