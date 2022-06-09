public final class NativeLogger {
	var handler: (LogRecord) -> Void = { _ in }

	internal func log (message: LogMessage, requestInfo: RequestInfo, requestDelegateName: String) {
		let record = LogRecord(
			requestInfo: requestInfo,
			requestDelegateName: requestDelegateName,
			message: message
		)

		handler(record)
	}

	func logging (_ handler: @escaping (LogRecord) -> Void) {
		self.handler = handler
	}
}
