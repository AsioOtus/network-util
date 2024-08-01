import Foundation

public protocol Request <Body> {
	associatedtype Body: Encodable = Data

	var address: String? { get }
	var body: Body? { get }
	var configuration: RequestConfiguration { get }
	var delegate: any RequestDelegate<Body> { get }

	func merge (with: RequestConfiguration) -> RequestConfiguration
}

public extension Request {
	var address: String? { nil }

	var body: Body? { nil }

	var configuration: RequestConfiguration { .init() }

	var delegate: any RequestDelegate<Body> { StandardRequestDelegate() }

	func merge (with configuration: RequestConfiguration) -> RequestConfiguration {
		self.configuration.merge(with: configuration)
	}
}
