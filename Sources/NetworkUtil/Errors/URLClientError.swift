import Foundation

public struct URLClientError: NetworkUtilError {
	public let requestId: UUID
	public let request: any Request
	public let category: Category
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

	var debugName: String {
		switch category {
		case .request: "request"
		case .network: "network"
		case .response: "response"
		case .unexpected: "unexpected"
		}
	}
}
