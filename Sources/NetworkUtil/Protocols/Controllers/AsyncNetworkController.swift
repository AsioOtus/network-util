public protocol AsyncNetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		interceptors: URLRequestInterceptor?
	) async throws -> StandardResponse

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interceptors: URLRequestInterceptor?
	) async throws -> RS

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptors: URLRequestInterceptor?
	) async throws -> StandardModelResponse<RSM>
}
