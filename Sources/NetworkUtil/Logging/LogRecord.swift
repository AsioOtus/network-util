import Foundation

public struct LogRecord {
	public let requestId: UUID
	public let request: Request
	public let message: LogMessage
}

extension LogRecord: CustomStringConvertible {
  public var info: String {
    [
      message.name.capitalized,
      requestId.description
    ].joined(separator: " | ")
  }

	public var description: String {
		"\(requestId) | \(message.name.capitalized) – \(message)"
	}
}
