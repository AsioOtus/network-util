import Foundation
import Combine

class Logger {
	private let recordSubject = PassthroughSubject<LogRecord, Never>()

  var logs: AsyncStream<LogRecord> {
    .init { continuation in
      let cancellable = recordSubject
        .sink {
          continuation.yield($0)
        }

      continuation.onTermination = { _ in
        cancellable.cancel()
      }
    }
  }

	init () { }

	func log (message: LogMessage, requestId: UUID, request: Request) {
		let record = LogRecord(
			requestId: requestId,
			request: request,
			message: message
		)

		recordSubject.send(record)
	}
}

extension Logger: Publisher {
	typealias Output = LogRecord
	typealias Failure = Never

	func receive <S> (subscriber: S) where S: Subscriber, S.Input == LogRecord, S.Failure == Never {
		recordSubject.receive(subscriber: subscriber)
	}
}
