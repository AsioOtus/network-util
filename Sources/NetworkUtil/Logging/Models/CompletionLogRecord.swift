import Foundation

public struct CompletionLogRecord {
    public let requestId: UUID
    public let request: any Request
    public let urlSession: URLSession?
    public let urlRequest: URLRequest?
    public let response: (data: Data, urlResponse: URLResponse)?
    public let error: APIClientError?

    init(
        requestId: UUID,
        request: any Request,
        urlSession: URLSession?,
        urlRequest: URLRequest?,
        response: (data: Data, urlResponse: URLResponse)?,
        error: APIClientError?
    ) {
        self.requestId = requestId
        self.request = request
        self.urlSession = urlSession
        self.urlRequest = urlRequest
        self.response = response
        self.error = error
    }
}
