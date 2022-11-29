import Foundation

public protocol URLRequestBuilder {
	func build <R: Request> (_ request: R) async throws -> URLRequest
}
