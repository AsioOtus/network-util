import Foundation

public struct NetworkError: NetworkUtilError {
    public let urlSession: URLSession
    public let urlRequest: URLRequest
    public let urlError: URLError

    public init (
        _ urlSession: URLSession,
        _ urlRequest: URLRequest,
        _ urlError: URLError
    ) {
        self.urlSession = urlSession
        self.urlRequest = urlRequest
        self.urlError = urlError
    }
}
