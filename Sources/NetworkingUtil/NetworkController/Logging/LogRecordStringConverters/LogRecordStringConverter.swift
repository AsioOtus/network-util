import Foundation

public protocol LogRecordStringConverter {
	func convert (_ record: Logger.LogRecord<Logger.BaseDetails>) -> String
}
