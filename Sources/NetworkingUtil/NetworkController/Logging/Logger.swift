import Foundation
import Combine

public class Logger {
    private var cancellables = Set<AnyCancellable>()
    
    public let onStart = PassthroughSubject<LogRecord<Any>, Never>()
    
    public let onRequest = PassthroughSubject<LogRecord<Request>, Never>()
    public let onUrlRequest = PassthroughSubject<LogRecord<(urlSession: URLSession, urlRequest: URLRequest)>, Never>()
    public let onUrlResponse = PassthroughSubject<LogRecord<(data: Data, urlResponse: URLResponse)>, Never>()
    public let onResponse = PassthroughSubject<LogRecord<Response>, Never>()
    public let onContent = PassthroughSubject<LogRecord<Any>, Never>()
    
    public let onUnmodifiedRequest = PassthroughSubject<LogRecord<Request>, Never>()
    public let onUnmodifiedUrlRequest = PassthroughSubject<LogRecord<(urlSession: URLSession, urlRequest: URLRequest)>, Never>()
    public let onModifiedUrlResponse = PassthroughSubject<LogRecord<(data: Data, urlResponse: URLResponse)>, Never>()
    public let onModifiedResponse = PassthroughSubject<LogRecord<Response>, Never>()
    public let onModifiedContent = PassthroughSubject<LogRecord<Any>, Never>()
    
    public let onError = PassthroughSubject<LogRecord<NetworkController.Error>, Never>()
    
    public let onMain: AnyPublisher<LogRecord<BaseDetails>, Never>
    
    init () {
        onMain = Publishers.Merge3(
            onUrlRequest.map { .init($0.requestInfo, .request($0.details.urlSession, $0.details.urlRequest)) },
            onUrlResponse.map { .init($0.requestInfo, .response($0.details.data, $0.details.urlResponse)) },
            onError.map { .init($0.requestInfo, .error($0.details)) }
        ).eraseToAnyPublisher()
    }
}

extension Logger {
	@discardableResult
	public func onDelegate (_ action: @escaping (LogRecord<Any>) -> Void) -> Self {
        onStart.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onRequest (_ action: @escaping (LogRecord<Request>) -> Void) -> Self {
		onRequest.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onUrlRequest (_ action: @escaping (LogRecord<(urlSession: URLSession, urlRequest: URLRequest)>) -> Void) -> Self {
		onUrlRequest.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onUrlResponse (_ action: @escaping (LogRecord<(data: Data, urlResponse: URLResponse)>) -> Void) -> Self {
		onUrlResponse.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onResponse (_ action: @escaping (LogRecord<Response>) -> Void) -> Self {
		onResponse.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onContent (_ action: @escaping (LogRecord<Any>) -> Void) -> Self {
		onContent.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	
	
	@discardableResult
	public func onUnmodifiedRequest (_ action: @escaping (LogRecord<Request>) -> Void) -> Self {
		onUnmodifiedRequest.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onUnmodifiedUrlRequest (_ action: @escaping (LogRecord<(urlSession: URLSession, urlRequest: URLRequest)>) -> Void) -> Self {
		onUnmodifiedUrlRequest.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onModifiedUrlResponse (_ action: @escaping (LogRecord<(data: Data, urlResponse: URLResponse)>) -> Void) -> Self {
		onModifiedUrlResponse.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onModifiedResponse (_ action: @escaping (LogRecord<Response>) -> Void) -> Self {
		onModifiedResponse.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	@discardableResult
	public func onModifiedContent (_ action: @escaping (LogRecord<Any>) -> Void) -> Self {
		onModifiedContent.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
	
	
	
	@discardableResult
	public func onError (_ action: @escaping (LogRecord<NetworkController.Error>) -> Void) -> Self {
		onError.sink(receiveValue: action).store(in: &cancellables)
		return self
	}
    
    
    
    @discardableResult
    public func onMain (_ action: @escaping (LogRecord<BaseDetails>) -> Void) -> Self {
        onMain.sink(receiveValue: action).store(in: &cancellables)
        return self
    }
}
