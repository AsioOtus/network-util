import Foundation
import Combine

public class Logger {
	private var subscriptions = Set<AnyCancellable>()
	internal let subject = PassthroughSubject<Record, Never>()
	public var publisher: AnyPublisher<Logger.Record, Never> { subject.eraseToAnyPublisher() }
	
	public init () { }
	
	internal func log (message: Message, requestInfo: RequestInfo, requestDelegateName: String) {
		let record = Record(
			requestInfo: requestInfo,
			requestDelegateName: requestDelegateName,
			message: message
		)
		
		subject.send(record)
	}
	
	func logging (_ handler: @escaping (Logger.Record) -> Void) {
		subject
			.sink(receiveValue: handler)
			.store(in: &subscriptions)
	}
}
