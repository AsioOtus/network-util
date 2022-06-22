import Foundation

public protocol ConfigurableRequest: Request {
	var method: String { get }
	var basePath: String { get }
	var path: String { get }

	var query: [String: String] { get }
	var headers: [String: String] { get }

	var urlComponents: URLComponents { get throws }
	var body: Data? { get throws }
}

public extension ConfigurableRequest {
	func defaultUrlComponents () throws -> URLComponents {
		guard var components = URLComponents(string: basePath)
		else { throw GeneralError.urlComponnetsCreationFailure(basePath) }
		components.path = path
		components.queryItems = query.map { .init(name: $0, value: $1) }
		return components
	}

	func defaultUrlRequest () throws -> URLRequest {
		let urlComponents = try urlComponents
		guard let url = urlComponents.url
		else { throw GeneralError.urlCreationFailure(urlComponents) }

		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = method
		urlRequest.httpBody = try body

		headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		return urlRequest
	}
}

public extension ConfigurableRequest {
	var query: [String: String] { [:] }
	var headers: [String: String] { [:] }

	var urlComponents: URLComponents { get throws { try defaultUrlComponents() } }
	var body: Data? { get throws { nil } }

	func urlRequest () throws -> URLRequest {
		try defaultUrlRequest()
	}
}
