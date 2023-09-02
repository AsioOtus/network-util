import Foundation
import Combine

public protocol CombineNetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interception: @escaping URLRequestInterception
	) -> AnyPublisher<RS, ControllerError>

	func send <RQ: Request> (
		_ request: RQ,
		interception: @escaping URLRequestInterception
	) -> AnyPublisher<StandardResponse, ControllerError>

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interception: @escaping URLRequestInterception
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError>
}

public extension CombineNetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		interception: @escaping URLRequestInterception = { $0 }
	) -> AnyPublisher<StandardResponse, ControllerError> {
		send(request, response: StandardResponse.self, interception: interception)
	}

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interception: @escaping URLRequestInterception = { $0 }
	) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError> {
		send(request, response: StandardModelResponse<RSM>.self, interception: interception)
	}
}
