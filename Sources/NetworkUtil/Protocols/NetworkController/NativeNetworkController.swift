import Foundation

public protocol NativeNetworkController {
    func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        label: String?,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onFailure: @escaping (RD.ErrorType) -> Void,
        onCompleted: @escaping () -> Void
    )

    func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        _ requestInfo: RequestInfo,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onFailure: @escaping (RD.ErrorType) -> Void,
        onCompleted: @escaping () -> Void
    )
}
