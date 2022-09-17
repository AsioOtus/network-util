import Foundation

public struct ControllerError: NetworkUtilError {
    let requestTypeName: String
    let category: Category

    init <R: Request> (requestType: R.Type, category: Category) {
        self.requestTypeName = String(describing: requestType)
        self.category = category
    }
}

extension ControllerError {
    public enum Category: NetworkUtilError {
        case creation(Error)
        case request(Error)
        case network(NetworkError)
        case response(Error)
        case content(Error)
        
        case general(GeneralError)
    }
}

public extension ControllerError {
    var innerError: Error {
        switch category {
        case .creation(let error): fallthrough
        case .request(let error): fallthrough
        case .network(let error as Error): return error
        case .response(let error): fallthrough
        case .content(let error): fallthrough
        case .general(let error as Error): return error
        }
    }

    var domainError: Error? {
        switch category {
        case .creation(let error): fallthrough
        case .content(let error): return error
        default: return nil
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
        case .creation: return "creation"
        case .request: return "request"
        case .network: return "network"
        case .response: return "response"
        case .content: return "content"
        case .general: return "general"
        }
    }
}

public extension ControllerError.Category {
    static func creationFailure (_ error: Error) -> Self {
        (error as? Self) ?? .creation(error)
    }

    static func requestFailure (_ error: Error) -> Self {
        (error as? Self) ?? .request(error)
    }

    static func networkFailure (_ error: NetworkError) -> Self {
        .network(error)
    }

    static func responseFailure (_ error: Error) -> Self {
        (error as? Self) ?? .response(error)
    }

    static func contentFailure (_ error: Error) -> Self {
        (error as? Self) ?? .content(error)
    }

    static func generalFailure (_ error: Error) -> Self {
        (error as? Self) ?? .general(.otherError(error))
    }
}
