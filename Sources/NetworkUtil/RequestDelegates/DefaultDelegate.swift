import Foundation

public struct JSONResponseDelegate <ResponseModel: Decodable>: RequestDelegate {
	public var name: String { "\(Self.self)" }

	private let request: Request

	public init (request: Request) {
		self.request = request
	}

	public func request (_ requestInfo: RequestInfo) throws -> URLRequest { try request.urlRequest() }

	public func content (_ response: StandardResponse, _ requestInfo: RequestInfo) throws -> ResponseModel {
		try JSONDecoder().decode(ResponseModel.self, from: response.data)
	}
}
