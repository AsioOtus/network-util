import Foundation

public struct URLClientError: NetworkUtilError {
	public let requestId: UUID
	public let request: any Request
	public let category: Category
}

extension URLClientError {
	public enum Category {
		case request(Error)
		case network(NetworkError)
		case response(Error)

		case unexpected(Error)

		var networkError: NetworkError? {
			if case .network(let error) = self { error }
			else { nil }
		}
	}
}

public extension URLClientError {
	var innerError: Error {
		switch category {
		case .request(let error): fallthrough
		case .network(let error as Error): fallthrough
		case .response(let error): fallthrough
		case .unexpected(let error): return error
		}
	}

	var name: String {
		switch category {
		case .request: return "request"
		case .network: return "network"
		case .response: return "response"
		case .unexpected: return "unexpected"
		}
	}
}
