import Foundation

public struct StandardResponse <Model: Decodable>: Response {
	public let data: Data
	public let urlResponse: URLResponse
	public let model: Model

	public init (_ data: Data, _ urlResponse: URLResponse, _ model: Model) throws {
		self.data = data
		self.urlResponse = urlResponse
		self.model = model
	}
}
