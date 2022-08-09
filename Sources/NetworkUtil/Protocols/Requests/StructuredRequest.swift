import Foundation

public protocol StructuredRequest: Request {
	var method: String { get }
	var path: String { get }

	var query: [String: String] { get }
	var headers: [String: String] { get }

	var body: Data? { get throws }
}

public extension StructuredRequest {
	var query: [String: String] { [:] }
	var headers: [String: String] { [:] }

	var body: Data? { get throws { nil } }
}

public extension StructuredRequest {
	func url () throws -> URL {
		guard var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponnetsCreationFailure("Request path: \(path)") }

		urlComponents.queryItems = query.map { key, value in .init(name: key, value: value) }

		guard let url = urlComponents.url
		else { throw GeneralError.urlCreationFailure(urlComponents) }

		return url
	}

	func urlRequest () throws -> URLRequest {
		let url = try url()
		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = method
		urlRequest.httpBody = try body

		headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

		return urlRequest
	}
}
