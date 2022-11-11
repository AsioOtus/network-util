import Foundation

public struct StandardResponse: Response {
	public let data: Data
	public let urlResponse: URLResponse

	public init (_ data: Data, _ urlResponse: URLResponse) {
		self.data = data
		self.urlResponse = urlResponse
	}
}
