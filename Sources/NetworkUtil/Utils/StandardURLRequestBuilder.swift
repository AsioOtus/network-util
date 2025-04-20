import Foundation

public struct StandardURLRequestBuilder {
    public init () { }
}

extension StandardURLRequestBuilder: URLRequestBuilder {
    public func build (address: String?, configuration: RequestConfiguration, body: Data?) throws -> URLRequest {
        let url = try buildUrl(address, configuration)

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = configuration.method?.value

        urlRequest.httpBody = body

        configuration.headers.forEach { key, value in urlRequest.setValue(value, forHTTPHeaderField: key) }

        if let builderTimeout = configuration.timeout {
            urlRequest.timeoutInterval = builderTimeout
        }

        if let cachePolicy = configuration.cachePolicy {
            urlRequest.cachePolicy = cachePolicy
        }

        return urlRequest
    }

    func buildUrl (_ address: String?, _ configuration: RequestConfiguration) throws -> URL {
        if let address {
            guard let url = URL(string: address) else { throw URLCreationError.addressFailure(address) }
            return url
        } else {
            let urlComponents = configuration.urlComponents
            guard let url = urlComponents.url else { throw URLCreationError.urlComponentsFailure(urlComponents) }
            return url
        }
    }
}

public extension URLRequestBuilder where Self == StandardURLRequestBuilder {
    static func standard () -> Self {
        .init()
    }
}
