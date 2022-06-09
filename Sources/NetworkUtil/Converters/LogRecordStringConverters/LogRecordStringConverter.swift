import Foundation

@available(iOS 13.0, *)
public protocol LogRecordStringConverter {
	func convert (_ record: LogRecord) -> String
}
