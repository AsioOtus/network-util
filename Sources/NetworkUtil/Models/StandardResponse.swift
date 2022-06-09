import Foundation

public struct StandardResponse: Response {
	public let data: Data
	public let urlResponse: URLResponse

	public init (_ data: Data, _ urlResponse: URLResponse) throws {
		self.data = data
		self.urlResponse = urlResponse
	}
}
