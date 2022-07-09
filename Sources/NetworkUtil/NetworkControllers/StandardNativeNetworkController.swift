import Foundation

public class StandardNativeNetworkController {
    public let identificationInfo: IdentificationInfo

    private let logger = NativeLogger()

	private var interceptors = [(URLRequest) throws -> URLRequest]()

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
        onCompletion: @escaping () -> Void = { }
    ) {
        let requestInfo = RequestInfo(
            uuid: UUID(),
            label: label,
            delegate: requestDelegate.name,
            controllers: []
        )

        return send(requestDelegate, requestInfo, onSuccess: onSuccess, onFailure: onFailure, onCompleted: onCompletion)
    }

    public func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        _ requestInfo: RequestInfo,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onFailure: @escaping (RD.ErrorType) -> Void  = { _ in },
        onCompletion: @escaping () -> Void  = { }
    ) {
        func onError (_ requestError: ControllerError) {
            self.logger.log(message: .error(requestError), requestInfo: requestInfo)
            onFailure(requestDelegate.error(requestError, requestInfo))
            onCompletion()
        }

        let requestInfo = requestInfo
            .add(identificationInfo)

        let request: RD.RequestType

        do {
            request = try requestDelegate.request(requestInfo)
        } catch {
            onError(ControllerError.creationFailure(error))
            return
        }

        let urlSession: URLSession
        var urlRequest: URLRequest

        do {
            urlSession = try requestDelegate.urlSession(request, requestInfo)
            urlRequest = try requestDelegate.urlRequest(request, requestInfo)

			try interceptors.forEach { urlRequest = try $0(urlRequest) }
        } catch {
            onError(ControllerError.requestFailure(error))
            return
        }

        logger.log(message: .request(urlSession, urlRequest), requestInfo: requestInfo)

        let task = urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error as? URLError {
                onError(ControllerError.networkFailure(NetworkError(urlSession, urlRequest, error)))
            } else if let error = error {
				onError(ControllerError.general(.urlErrorIsEmpty(error)))
            } else if let data = data, let urlResponse = urlResponse {
                self.logger.log(message: .response(data, urlResponse), requestInfo: requestInfo)

                let response: RD.ResponseType

                do {
                    response = try requestDelegate.response(data, urlResponse, requestInfo)
                } catch {
                    onError(ControllerError.responseFailure(error))
                    return
                }

                let content: RD.ContentType

                do {
                    content = try requestDelegate.content(response, requestInfo)
                } catch {
                    onError(ControllerError.contentFailure(error))
                    return
                }

                onSuccess(content)
                onCompletion()
            } else {
				onError(ControllerError.general(.urlResponseContentIsEmpty))
            }
        }

        task.resume()
    }
}

public extension StandardNativeNetworkController {
    @discardableResult
    func logging (_ handler: @escaping (LogRecord) -> Void) -> Self {
        logger.logging(handler)
        return self
    }

	@discardableResult
	func add (interseptor: @escaping (URLRequest) throws -> URLRequest) -> Self {
		interceptors.append(interseptor)
		return self
	}
}
