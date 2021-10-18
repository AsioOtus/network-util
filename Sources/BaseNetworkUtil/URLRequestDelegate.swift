import Foundation

public extension URLRequest {
	struct Response: BaseNetworkUtil.Response {
		public let data: Data
		public let urlResponse: URLResponse
		
		public init (_ data: Data, _ urlResponse: URLResponse) throws {
			self.data = data
			self.urlResponse = urlResponse
		}
	}
}

extension URLRequest: RequestDelegate {	
	public func request (_ requestInfo: RequestInfo) -> URLRequest {
		self
	}
	
	public func content (_ response: Response, _ requestInfo: RequestInfo) -> (data: Data, urlResponse: URLResponse) {
		(response.data, response.urlResponse)
	}
}
