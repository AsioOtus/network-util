import Foundation
import Combine

typealias CompletionLogger = PassthroughSubject<CompletionLogRecord, Never>

extension CompletionLogger {
    func log (
        requestId: UUID,
        request: any Request,
        urlSession: URLSession?,
        urlRequest: URLRequest?,
        response: (data: Data, urlResponse: URLResponse)?,
        error: APIClientError?
    ) {
        send(
            .init(
                requestId: requestId,
                request: request,
                urlSession: urlSession,
                urlRequest: urlRequest,
                response: response,
                error: error
            )
        )
    }
}
