extension URLClientError {
    public enum Category: Error {
        case request(Error)
        case network(NetworkError)
        case response(Error)
        
        case general(Error)
    }
}

extension URLClientError.Category {
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
