import Foundation

public enum LogMessage {
	case request(URLSession, URLRequest)
	case response(Data, URLResponse)
	case error(RequestError)

	public var typeName: String {
		switch self {
		case .request: return "request"
		case .response: return "response"
		case .error: return "error"
		}
	}
}
