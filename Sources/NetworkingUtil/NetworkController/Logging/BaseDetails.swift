import Foundation

extension Logger {
	public enum BaseDetails {
		case request(URLSession, URLRequest)
		case response(Data, URLResponse)
		case error(NetworkController.Error)
		
		public var type: String {
			switch self {
			case .request:
				return "request"
			case .response:
				return "response"
			case .error:
				return "error"
			}
		}
	}
}

public extension Logger.LogRecord where Details == Logger.BaseDetails {
	func convert (_ converter: LogRecordStringConverter) -> String {
		converter.convert(self)
	}
}
