public struct LogRecord {
	public let requestInfo: RequestInfo
	public let requestDelegateName: String
	public let message: LogMessage
}

public extension LogRecord {
	func convert (_ converter: LogRecordStringConverter) -> String {
		converter.convert(self)
	}
}
