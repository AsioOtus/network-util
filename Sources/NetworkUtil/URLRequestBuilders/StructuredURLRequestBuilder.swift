import Foundation

open class StructuredURLRequestBuilder {
    public let scheme: String?
    public let basePath: String
    public let query: [String: String]
    public let headers: [String: String]

    public init (scheme: String? = nil ,basePath: String, query: [String: String] = [:], headers: [String: String] = [:]) {
        self.scheme = scheme
        self.basePath = basePath
        self.query = query
        self.headers = headers
    }

    open func url (_ request: StructuredRequest, _ requestInfo: RequestInfo) throws -> URL {
        let basePath = request.basePath ?? basePath
        let path = URL(string: basePath)?.appendingPathComponent(request.subpath).absoluteString

        guard
            let path = path,
            var urlComponents = URLComponents(string: path)
        else { throw GeneralError.urlComponentsCreationFailure("Base path: \(basePath) – Request path: \(request.subpath)") }

        urlComponents.scheme = request.scheme ?? scheme

        let query = request.query.merging(query) { value, _ in value }
        urlComponents.queryItems = query.map { key, value in .init(name: key, value: value) }

        guard let url = urlComponents.url
        else { throw GeneralError.urlCreationFailure(urlComponents) }

        return url
    }
}

extension StructuredURLRequestBuilder: URLRequestBuilder {
    open func build <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLRequest {
        guard let structuredRequest = request as? StructuredRequest else {
            return try request.urlRequest()
        }

        let url = try url(structuredRequest, requestInfo)
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = structuredRequest.method.stringValue
        urlRequest.httpBody = try structuredRequest.body

        let headers = structuredRequest.headers.merging(headers) { value, _ in value }
        headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

        return urlRequest
    }
}

public extension URLRequestBuilder where Self == StructuredURLRequestBuilder {
    static func structured (
        basePath: String,
        query: [String: String] = [:],
        headers: [String: String] = [:]
    ) -> StructuredURLRequestBuilder {
        .init(
            basePath: basePath,
            query: query,
            headers: headers
        )
    }
}
