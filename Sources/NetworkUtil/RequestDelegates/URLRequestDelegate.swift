import Foundation

extension URLRequest: RequestDelegate {
	public typealias ResponseType = StandardResponse
	
	public var name: String { "\(Self.self)" }
	
	public func request (_ requestInfo: RequestInfo) -> URLRequest { self }
}
