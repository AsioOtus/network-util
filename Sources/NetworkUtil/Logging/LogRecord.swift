import Foundation

public struct LogRecord {
	public let requestId: UUID
	public let request: any Request
	public let message: LogMessage
}

extension LogRecord: CustomStringConvertible {
  public var info: String {
    [
      message.debugName.capitalized,
      requestId.description
    ].joined(separator: " | ")
  }

	public var description: String {
		"\(requestId) | \(message.debugName.capitalized) – \(message)"
	}
}
