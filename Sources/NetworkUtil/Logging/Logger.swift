import Foundation
import Combine

struct Logger {
	private let subject = PassthroughSubject<LogRecord, Never>()

	init () { }

	func log (message: LogMessage, requestId: UUID, request: Request) {
		let record = LogRecord(
			requestId: requestId,
			request: request,
			message: message
		)

		subject.send(record)
	}
}

extension Logger: Publisher {
	typealias Output = LogRecord
	typealias Failure = Never

	func receive <S> (subscriber: S) where S: Subscriber, S.Input == LogRecord, S.Failure == Never {
		subject.receive(subscriber: subscriber)
	}
}
