import Foundation

extension URLRequest: RequestDelegate {
	public var name: String { "\(Self.self)" }

	public func request (_ requestInfo: RequestInfo) -> URLRequest { self }

	public func content (_ response: StandardResponse, _ requestInfo: RequestInfo) -> (data: Data, urlResponse: URLResponse) {
		(response.data, response.urlResponse)
	}
}
