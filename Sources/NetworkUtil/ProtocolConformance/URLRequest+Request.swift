import Foundation

extension URLRequest: Request {
    public var body: Body? { httpBody }

    public var configuration: RequestConfiguration {
        .init(
            method: httpMethod.map { RequestConfiguration.Method($0) },
            urlComponents: .init(),
            address: url?.absoluteString,
            headers: allHTTPHeaderFields ?? [:],
            timeout: timeoutInterval,
            cachePolicy: cachePolicy
        )
    }
}
