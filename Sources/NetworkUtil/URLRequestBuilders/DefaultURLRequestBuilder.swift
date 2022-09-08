import Foundation

public struct DefaultURLRequestBuilder {
    public static let `default` = Self()

	public init () { }
}

extension DefaultURLRequestBuilder: URLRequestBuilder {
    public func build <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLRequest {
        try request.urlRequest()
    }
}

public extension URLRequestBuilder where Self == DefaultURLRequestBuilder {
    static var `default`: DefaultURLRequestBuilder { .default }
}
