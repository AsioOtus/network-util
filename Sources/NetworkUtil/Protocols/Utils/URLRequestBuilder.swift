import Foundation

public protocol URLRequestBuilder {
	func build (address: String?, configuration: RequestConfiguration, body: Data?) throws -> URLRequest
}
