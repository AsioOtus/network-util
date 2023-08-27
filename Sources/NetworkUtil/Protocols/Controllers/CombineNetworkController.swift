import Foundation
import Combine

public protocol CombineNetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interceptor: some URLRequestInterceptor
	) -> AnyPublisher<RS, ControllerError>

	func send <RQ: Request> (
		_ request: RQ,
		interceptor: some URLRequestInterceptor
	) -> AnyPublisher<StandardResponse, ControllerError>

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptor: some URLRequestInterceptor
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError>
}

public extension CombineNetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		interceptor: some URLRequestInterceptor
	) -> AnyPublisher<StandardResponse, ControllerError> {
		send(request, response: StandardResponse.self, interceptor: interceptor)
	}

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptor: some URLRequestInterceptor
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError> {
		send(request, response: StandardModelResponse<RSM>.self, interceptor: interceptor)
	}
}

public extension CombineNetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) -> AnyPublisher<RS, ControllerError> {
		send(request, response: RS.self, interceptor: .compact(interception))
	}

	func send <RQ: Request> (
		_ request: RQ,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) -> AnyPublisher<StandardResponse, ControllerError> {
		send(request, response: StandardResponse.self, interception: interception)
	}

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError> {
		send(request, response: StandardModelResponse<RSM>.self, interception: interception)
	}
}
