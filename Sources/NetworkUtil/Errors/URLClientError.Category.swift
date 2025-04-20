import Foundation

extension URLClientError {
    public enum Category: Error {
        case request(Error)
        case network(NetworkError)
        case response(Error)
        
        case general(Error)
    }
}

extension URLClientError.Category {
    var innerError: Error {
        switch self {
        case .request(let error): fallthrough
        case .network(let error as Error): fallthrough
        case .response(let error): fallthrough
        case .general(let error): return error
        }
    }

    public var requestError: Error? {
        if case .request(let error) = self { error }
        else { nil }
    }
    
    public var networkError: NetworkError? {
        if case .network(let error) = self { error }
        else { nil }
    }
    
    public var responseError: Error? {
        if case .response(let error) = self { error }
        else { nil }
    }
    
    public var generalError: Error? {
        if case .general(let error) = self { error }
        else { nil }
    }
}

extension URLClientError.Category {
    var debugName: String {
        switch self {
        case .request: "request"
        case .network: "network"
        case .response: "response"
        case .general: "general"
        }
    }
}

extension URLClientError.Category {
    var localizedDescription: String {
        .init(describing: innerError)
    }
}
