import Foundation

public enum RequestError: NetworkUtilError {
    case request(Error)
    case network(Error)
    case content(Error)
    
    public var innerError: Error {
        switch self {
        case .request(let error): fallthrough
        case .network(let error): fallthrough
        case .content(let error): return error
        }
    }
    
    public var domainError: Error? {
        switch self {
        case .request(let error): fallthrough
        case .content(let error): return error
        default: return nil
        }
    }
    
    public var networkError: Error? {
        switch self {
        case .network(let error): return error
        default: return nil
        }
    }
    
    public var name: String {
        switch self {
        case .request: return "request"
        case .network: return "network"
        case .content: return "content"
        }
    }
}

public  extension RequestError {
    static func requestFailure (error: Error) -> Self {
        (error as? Self) ?? .request(error)
    }
    
    static func networkFailure (error: Error) -> Self {
        (error as? Self) ?? .network(error)
    }
    
    static func contentFailure (error: Error) -> Self {
        (error as? Self) ?? .content(error)
    }
}
