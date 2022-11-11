import Foundation

public struct LogRecord {
	public let requestId: UUID
	public let request: Request
	public let message: LogMessage
}

extension LogRecord: CustomStringConvertible {
	public var description: String {
		"Request – \(requestId) | \(message.name.capitalized) – \(message)"
	}
}
