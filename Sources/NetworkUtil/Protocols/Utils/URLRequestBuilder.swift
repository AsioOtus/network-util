import Foundation

public protocol URLRequestBuilder {
	func build (_ request: some Request, _ config: URLRequestConfiguration) async throws -> URLRequest
}
