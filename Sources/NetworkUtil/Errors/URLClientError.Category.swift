extension URLClientError {
    public enum Category {
        case request(Error)
        case network(NetworkError)
        case response(Error)
        
        case unexpected(Error)
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
    
    public var unexpectedError: Error? {
        if case .unexpected(let error) = self { error }
        else { nil }
    }
}
