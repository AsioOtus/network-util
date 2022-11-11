import Foundation

public protocol JSONResponseModel: ResponseModel { }

public extension JSONResponseModel {
	init (_ data: Data) throws {
		self = try JSONDecoder().decode(Self.self, from: data)
	}
}
