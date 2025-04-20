import Foundation
import Combine

typealias Logger = PassthroughSubject<LogRecord, Never>

extension Logger {
    func log (
        message: LogMessage,
        requestId: UUID,
        request: any Request,
        completion: LogCompletion?
    ) {
        send(
            .init(
                requestId: requestId,
                request: request,
                message: message,
                completion: completion
            )
        )
    }
}
