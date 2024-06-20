import Foundation

public enum LogMessage {
	case request(URLSession, URLRequest)
	case response(Data, URLResponse)
	case error(ControllerError)

	public var name: String {
		switch self {
		case .request: "request"
		case .response: "response"
		case .error: "error"
		}
	}
}

extension LogMessage: CustomStringConvertible {
	public var description: String {
		switch self {
		case .request(_, let urlRequest): urlRequest.description
		case .response(_, let urlResponse): urlResponse.description
		case .error(let error): "\(error.name): \(error.innerError.localizedDescription)"
		}
	}
}

public extension LogMessage {
	var urlRequest: URLRequest? {
		if case .request(_, let urlRequest) = self {
			urlRequest
		} else {
			nil
		}
	}
}
