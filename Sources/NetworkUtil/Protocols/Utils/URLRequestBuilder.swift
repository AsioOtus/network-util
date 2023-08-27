import Foundation

public protocol URLRequestBuilder {
	func build <R: Request> (_ request: R, _ config: URLRequestConfiguration) async throws -> URLRequest
}
