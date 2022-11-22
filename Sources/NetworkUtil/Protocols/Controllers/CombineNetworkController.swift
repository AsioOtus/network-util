import Foundation
import Combine

public protocol CombineNetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		interceptor: (some URLRequestInterceptor)?
	) -> AnyPublisher<StandardResponse, ControllerError>

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interceptor: (some URLRequestInterceptor)?
	) -> AnyPublisher<RS, ControllerError>

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptor: (some URLRequestInterceptor)?
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError>

	func send <RQ: Request> (
		_ request: RQ,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) -> AnyPublisher<StandardResponse, ControllerError>

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) -> AnyPublisher<RS, ControllerError>

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError>
}
