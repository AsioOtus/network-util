import Foundation

public struct StandardResponse <Model: Decodable>: Response {
	public let data: Data
	public let urlResponse: URLResponse
	public let model: Model

	public var httpUrlResponse: HTTPURLResponse? {
		urlResponse as? HTTPURLResponse
	}

	public init (data: Data = .init(), urlResponse: URLResponse, model: Model) {
		self.data = data
		self.urlResponse = urlResponse
		self.model = model
	}
}
