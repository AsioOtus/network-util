import Foundation
import Combine

@available(iOS 13.0, *)
public final class Logger {
	private var subscriptions = Set<AnyCancellable>()
	internal let subject = PassthroughSubject<LogRecord, Never>()
	public var publisher: AnyPublisher<LogRecord, Never> { subject.eraseToAnyPublisher() }

	public init () { }

	internal func log (message: LogMessage, requestInfo: RequestInfo, requestDelegateName: String) {
		let record = LogRecord(
			requestInfo: requestInfo,
			requestDelegateName: requestDelegateName,
			message: message
		)

		subject.send(record)
	}

	func logging (_ handler: @escaping (LogRecord) -> Void) {
		subject
			.sink(receiveValue: handler)
			.store(in: &subscriptions)
	}
}
