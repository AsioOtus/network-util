import Foundation

public protocol URLSessionBuilder {
	func build (configuration: RequestConfiguration) throws -> URLSession
}
