import Foundation

public protocol ConfigurableModellableRequest: ConfigurableRequest, ModellableRequest {
	func urlRequest () throws -> URLRequest
}

public extension ConfigurableModellableRequest {
	var defaultBody: Data? { get throws { try model.data() } }
}

public extension ConfigurableModellableRequest {
	var body: Data? { get throws { try defaultBody } }
}
