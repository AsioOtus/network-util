import Foundation

public protocol RequestBodyEncoder {
	func encode <T: Encodable> (_ t: T) throws -> Data
}
