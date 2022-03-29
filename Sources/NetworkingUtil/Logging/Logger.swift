import Foundation
import Combine

public class Logger {
    private let subject = PassthroughSubject<Record, Never>()
    
    public init () { }
    
    public func log (message: Message, requestInfo: RequestInfo, requestDelegateName: String) {
        let record = Record(
            requestInfo: requestInfo,
            requestDelegateName: requestDelegateName,
            message: message
        )
        
        subject.send(record)
    }
}
