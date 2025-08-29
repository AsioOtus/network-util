import Foundation

public protocol URLRequestBuilder {
	func build (configuration: RequestConfiguration, body: Data?) throws -> URLRequest
}
