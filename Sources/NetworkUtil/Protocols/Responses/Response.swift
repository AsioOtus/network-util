import Foundation

public protocol Response <Model>: CustomStringConvertible {
	associatedtype Model: Decodable = Data

	var data: Data { get }
	var urlResponse: URLResponse { get }
	var model: Model { get }

	init (_ data: Data, _ urlResponse: URLResponse, _ model: Model) throws
}

public extension Response {
	var description: String { urlResponse.description }
}
