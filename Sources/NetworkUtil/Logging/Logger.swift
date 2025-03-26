import Foundation
import Combine

typealias Logger = PassthroughSubject<LogRecord, Never>

extension Logger {
    func log (message: LogMessage, requestId: UUID, request: any Request) {
        let record = LogRecord(
            requestId: requestId,
            request: request,
            message: message
        )

        send(record)
    }
}
