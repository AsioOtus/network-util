import Foundation

public struct StandardModelResponse <Model: ResponseModel>: ModellableResponse {
	public let data: Data
	public let urlResponse: URLResponse
	public let model: Model

	public init (_ data: Data, _ urlResponse: URLResponse) throws {
		self.data = data
		self.urlResponse = urlResponse
		self.model = try .init(data)
	}
}
