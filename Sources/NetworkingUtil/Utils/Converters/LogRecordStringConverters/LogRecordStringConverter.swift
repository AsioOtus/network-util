import Foundation

public protocol LogRecordStringConverter {
	func convert (_ record: Logger.Record) -> String
}
