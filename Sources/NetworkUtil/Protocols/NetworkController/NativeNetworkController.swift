import Foundation

public protocol NativeNetworkController {
	func send <RQ: Request, RS: Response> (
		request: RQ,
		response: RS.Type,
		label: String?,
		onSuccess: @escaping (RS) -> Void,
		onFailure: @escaping (ControllerError) -> Void,
		onCompletion: @escaping () -> Void
	)

    func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        label: String?,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onFailure: @escaping (RD.ErrorType) -> Void,
        onCompletion: @escaping () -> Void
    )

    func send <RD: RequestDelegate> (
        _ requestDelegate: RD,
        _ requestInfo: RequestInfo,
        onSuccess: @escaping (RD.ContentType) -> Void,
        onFailure: @escaping (RD.ErrorType) -> Void,
		onCompletion: @escaping () -> Void
    )
}
