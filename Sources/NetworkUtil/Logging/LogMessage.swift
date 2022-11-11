import Foundation

public enum LogMessage {
	case request(URLSession, URLRequest)
	case response(Data, URLResponse)
	case error(ControllerError)

	public var name: String {
		switch self {
		case .request: return "request"
		case .response: return "response"
		case .error: return "error"
		}
	}
}

extension LogMessage: CustomStringConvertible {
	public var description: String {
		switch self {
		case .request(_, let urlRequest): return urlRequest.description
		case .response(_, let urlResponse): return urlResponse.description
		case .error(let error): return "\(error.name): \(error.innerError.localizedDescription)"
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
