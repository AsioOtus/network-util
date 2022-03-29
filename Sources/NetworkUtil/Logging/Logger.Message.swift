import Foundation

extension Logger {
	public enum Message {
		case request(URLSession, URLRequest)
		case response(Data, URLResponse)
		case error(NetworkError)
		
		public var typeName: String {
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
