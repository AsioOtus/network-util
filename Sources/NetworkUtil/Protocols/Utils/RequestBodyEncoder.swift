import Foundation

public protocol RequestBodyEncoder {
	func encode <T: Encodable> (_ t: T) throws -> Data
}

public extension RequestBodyEncoder {
	func encode (_ data: Data) throws -> Data {
		data
	}
}
