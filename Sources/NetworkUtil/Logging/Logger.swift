import Foundation
import Combine

public final class Logger {
	private let subject = PassthroughSubject<LogRecord, Never>()

	public init () { }

	internal func log (message: LogMessage, requestId: UUID, request: Request) {
		let record = LogRecord(
			requestId: requestId,
			request: request,
			message: message
		)

		subject.send(record)
	}
}

extension Logger: Publisher {
	public typealias Output = LogRecord
	public typealias Failure = Never

	public func receive <S> (subscriber: S) where S: Subscriber, S.Input == LogRecord, S.Failure == Never {
		subject.receive(subscriber: subscriber)
	}
}
