import Foundation

public protocol StructuredRequest: Request {
    var basePath: String? { get }

    var method: String { get }
	var path: String { get }

	var query: [String: String] { get }
	var headers: [String: String] { get }

	var body: Data? { get throws }
}

public extension StructuredRequest {
    var basePath: String? { nil }
	var query: [String: String] { [:] }
	var headers: [String: String] { [:] }

	var body: Data? { get throws { nil } }
}

public extension StructuredRequest {
	func url () throws -> URL {
        let path = basePath ?? path

		guard var urlComponents = URLComponents(string: path)
		else { throw GeneralError.urlComponentsCreationFailure("Request path: \(path)") }

		urlComponents.queryItems = query.map { key, value in .init(name: key, value: value) }

		guard var url = urlComponents.url
		else { throw GeneralError.urlCreationFailure(urlComponents) }

        if basePath != nil {
            url.appendPathComponent(path)
        }

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
