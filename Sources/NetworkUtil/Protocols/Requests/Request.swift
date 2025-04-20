import Foundation

public protocol Request <Body> {
	associatedtype Body: Encodable = Data

    var name: String { get }
	var address: String? { get }
	var body: Body? { get }
	var configuration: RequestConfiguration { get }
	var delegate: any RequestDelegate<Body> { get }

	func mergeConfiguration (with: RequestConfiguration) -> RequestConfiguration
}

public extension Request {
    var name: String { .init(describing: Self.self) }

	var address: String? { nil }

	var body: Body? { nil }

	var configuration: RequestConfiguration { .init() }

	var delegate: any RequestDelegate<Body> { StandardRequestDelegate() }

	func mergeConfiguration (with configuration: RequestConfiguration) -> RequestConfiguration {
		self.configuration.merge(with: configuration)
	}
}
