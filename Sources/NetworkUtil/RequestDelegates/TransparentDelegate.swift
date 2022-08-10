import Foundation

public struct TransparentDelegate <ResponseType: Response>: RequestDelegate {
	public typealias ResponseType = ResponseType

	private let request: Request

	public init (request: Request, response: ResponseType.Type) {
		self.request = request
	}

	public func request (_ requestInfo: RequestInfo) throws -> URLRequest { try request.urlRequest() }
}
