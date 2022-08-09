import Foundation

extension URL: RequestDelegate {
    public var name: String { "\(Self.self)" }

    public func request (_ requestInfo: RequestInfo) -> URLRequest { .init(url: self) }

	public func content (_ response: StandardResponse, _ requestInfo: RequestInfo) -> (data: Data, urlResponse: URLResponse) {
		(response.data, response.urlResponse)
	}
}
