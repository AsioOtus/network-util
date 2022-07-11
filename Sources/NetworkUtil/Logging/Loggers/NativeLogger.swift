public final class NativeLogger {
	var handler: (LogRecord) -> Void = { _ in }

	internal func log (message: LogMessage, requestInfo: RequestInfo) {
		let record = LogRecord(
			requestInfo: requestInfo,
			message: message
		)

		handler(record)
	}

	func logging (_ handler: @escaping (LogRecord) -> Void) {
		self.handler = handler
	}
}
