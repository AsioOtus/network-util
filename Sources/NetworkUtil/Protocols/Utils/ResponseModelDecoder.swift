import Foundation

public protocol ResponseModelDecoder {
	func decode <T: Decodable> (_ type: T.Type, from data: Data) throws -> T
}

public extension RequestBodyEncoder {
	func decode (_ type: Data.Type, from data: Data) throws -> Data {
		data
	}
}
