import Foundation

public protocol JSONRequestModel: RequestModel { }

public extension JSONRequestModel {
	func data () throws -> Data { try JSONEncoder().encode(self) }
}
