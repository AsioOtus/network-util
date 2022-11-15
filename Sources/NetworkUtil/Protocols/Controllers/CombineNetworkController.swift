import Combine

public protocol CombineNetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		interceptors: URLRequestInterceptor?
	) -> AnyPublisher<StandardResponse, ControllerError>

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interceptors: URLRequestInterceptor?
	) -> AnyPublisher<RS, ControllerError>

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptors: URLRequestInterceptor?
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError>
}
