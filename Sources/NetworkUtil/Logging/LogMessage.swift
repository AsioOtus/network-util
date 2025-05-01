import Foundation

public enum LogMessage {
	case request(URLSession, URLRequest)
	case response(Data, URLResponse)
	case error(APIClientError)

	public var debugName: String {
		switch self {
		case .request: "request"
		case .response: "response"
		case .error: "error"
		}
	}
}

public extension LogMessage {
    var request: (URLSession,  URLRequest)? {
        if case .request(let urlSession, let urlRequest) = self { (urlSession, urlRequest) }
        else { nil }
    }

    var response: (Data,  URLResponse)? {
        if case .response(let data, let urlResponse) = self { (data, urlResponse) }
        else { nil }
    }

    var error: APIClientError? {
        if case .error(let apiClientError) = self { apiClientError }
        else { nil }
    }
}

extension LogMessage: CustomStringConvertible {
	public var description: String {
		switch self {
		case .request(_, let urlRequest): urlRequest.description
		case .response(_, let urlResponse): urlResponse.description
        case .error(let error): "\(error.debugName): \(error.innerError.localizedDescription)"
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
