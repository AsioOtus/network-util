import Foundation

public enum LogMessage {
	case request(URLSession, URLRequest)
	case response(Data, URLResponse)
	case error(ControllerError)

	public var typeName: String {
		switch self {
		case .request: return "request"
		case .response: return "response"
		case .error: return "error"
		}
	}
}

public extension LogMessage {
	var urlRequest: URLRequest? {
		if case .request(_, let urlRequest) = self {
			return urlRequest
		} else {
			return nil
		}
	}
}
