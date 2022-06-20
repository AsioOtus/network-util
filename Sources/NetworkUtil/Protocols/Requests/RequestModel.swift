import Foundation

public protocol RequestModel: Encodable {
	func data () throws -> Data
}
