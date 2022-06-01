import Foundation

public protocol NativeNetworkController {
    func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        label: String?,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onCompleted: @escaping (Result<Void, RD.ErrorType>) -> Void
    )
    
    func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        _ requestInfo: RequestInfo,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onCompleted: @escaping (Result<Void, RD.ErrorType>) -> Void
    )
}
