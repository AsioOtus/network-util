import Foundation

public protocol URLRequestBuilder {
    func build <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLRequest
}
