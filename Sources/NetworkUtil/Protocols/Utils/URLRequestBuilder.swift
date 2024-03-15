import Foundation

public protocol URLRequestBuilder {
	func build (_ request: some Request, _ body: Data, _ config: URLRequestConfiguration) throws -> URLRequest
}
