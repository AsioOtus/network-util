import Foundation

public struct LogRecord {
    public let requestId: UUID
    public let request: any Request
    public let message: LogMessage
    public let completion: LogCompletion?
}

extension LogRecord: CustomStringConvertible {
    public var info: String {
        "\(message.debugName.capitalized) | \(requestId.description)"
    }

    public var description: String {
        "\(requestId) | \(message.debugName.capitalized) – \(message)"
    }
}

public struct LogCompletion {
    public let urlRequest: URLRequest?
    public let data: Data?
    public let urlResponse: URLResponse?
    public let error: URLClientError?
}
