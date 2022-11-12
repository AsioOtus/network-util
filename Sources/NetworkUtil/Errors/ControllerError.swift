import Foundation

public struct ControllerError: NetworkUtilError {
	let requestId: UUID
	let request: Request
	let category: Category
}

extension ControllerError {
	public enum Category {
		case request(Error)
		case network(NetworkError)
		case response(Error)

		case general(GeneralError)
	}
}

public extension ControllerError {
	var innerError: Error {
		switch category {
		case .request(let error): fallthrough
		case .network(let error as Error): return error
		case .response(let error): fallthrough
		case .general(let error as Error): return error
		}
	}

	var networkError: NetworkError? {
		switch category {
		case .network(let error): return error
		default: return nil
		}
	}

	var name: String {
		switch category {
		case .request: return "request"
		case .network: return "network"
		case .response: return "response"
		case .general: return "general"
		}
	}
}
