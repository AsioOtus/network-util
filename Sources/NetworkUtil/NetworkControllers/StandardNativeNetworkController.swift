import Foundation

public class StandardNativeNetworkController {
    public let identificationInfo: IdentificationInfo
    
    private let logger = Logger()
    
    public init (
        label: String? = nil,
        file: String = #fileID,
        line: Int = #line
    ) {
        self.identificationInfo = IdentificationInfo(
            module: Info.moduleName,
            type: String(describing: Self.self),
            file: file,
            line: line,
            label: label
        )
    }
}

extension StandardNativeNetworkController: NativeNetworkController {
    public func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        label: String? = nil,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onFailure: @escaping (RD.ErrorType) -> Void = { _ in },
        onCompleted: @escaping () -> Void = { }
    ) {
        let requestInfo = RequestInfo(
            uuid: UUID(),
            label: label,
            delegate: requestDelegate.name,
            controllers: []
        )

        return send(requestDelegate, requestInfo, onSuccess: onSuccess, onFailure: onFailure, onCompleted: onCompleted)
    }
    
    public func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        _ requestInfo: RequestInfo,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onFailure: @escaping (RD.ErrorType) -> Void  = { _ in },
        onCompleted: @escaping () -> Void  = { }
    ) {
        func onError (_ requestError: RequestError) {
            self.logger.log(message: .error(requestError), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
            onFailure(requestDelegate.error(requestError, requestInfo))
            onCompleted()
        }
        
        let requestInfo = requestInfo
            .add(identificationInfo)
        
        let request: RD.RequestType
        
        do {
            request = try requestDelegate.request(requestInfo)
        } catch {
            onError(RequestError.requestFailure(error))
            return
        }
        
        let urlSession: URLSession
        let urlRequest: URLRequest
        
        do {
            urlSession = try requestDelegate.urlSession(request, requestInfo)
            urlRequest = try requestDelegate.urlRequest(request, requestInfo)
        } catch {
            onError(RequestError.networkFailure(error))
            return
        }
        
        logger.log(message: .request(urlSession, urlRequest), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
        
        let task = urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error as? URLError {
                onError(RequestError.networkFailure(NetworkError(urlSession, urlRequest, error)))
                return
            } else if let error = error {
                onError(RequestError.networkFailure(error))
                return
            } else if let data = data, let urlResponse = urlResponse {
                self.logger.log(message: .response(data, urlResponse), requestInfo: requestInfo, requestDelegateName: requestDelegate.name)
                
                let response: RD.ResponseType
                
                do {
                    response = try requestDelegate.response(data, urlResponse, requestInfo)
                } catch {
                    onError(RequestError.networkFailure(error))
                    return
                }
                
                let content: RD.ContentType
                
                do {
                    content = try requestDelegate.content(response, requestInfo)
                } catch {
                    onError(RequestError.contentFailure(error))
                    return
                }
                
                onSuccess(content)
                onCompleted()
            } else {
                onError(RequestError.networkFailure(UnexpectedError()))
            }
        }
        
        task.resume()
    }
}

public extension StandardNativeNetworkController {
    @discardableResult
    func loggerSetup (_ logging: (Logger) -> Void) -> Self {
        logging(logger)
        return self
    }
    
    @discardableResult
    func logging (_ handler: @escaping (Logger.Record) -> Void) -> Self {
        logger.logging(handler)
        return self
    }
}
