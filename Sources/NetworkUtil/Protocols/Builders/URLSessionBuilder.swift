import Foundation

public protocol URLSessionBuilder {
    func build <R: Request> (_ request: R, _ requestInfo: RequestInfo) throws -> URLSession
}
