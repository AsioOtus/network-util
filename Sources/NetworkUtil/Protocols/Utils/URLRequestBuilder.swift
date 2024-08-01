import Foundation

public protocol URLRequestBuilder {
	func build (_: String?, _: RequestConfiguration, _: Data?) throws -> URLRequest
}
