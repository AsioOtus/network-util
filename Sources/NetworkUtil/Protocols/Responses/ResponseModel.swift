import Foundation

public protocol ResponseModel: Decodable {
	init (_ data: Data) throws
}
