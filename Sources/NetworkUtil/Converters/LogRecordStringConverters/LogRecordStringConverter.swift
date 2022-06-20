import Foundation

public protocol LogRecordStringConverter {
	func convert (_ record: LogRecord) -> String
}
