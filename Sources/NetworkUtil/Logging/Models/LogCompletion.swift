import Foundation

public struct LogCompletion {
    public let urlRequest: URLRequest?
    public let responseData: Data?
    public let urlResponse: URLResponse?
    public let error: APIClientError?
}
