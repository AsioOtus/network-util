import Combine

public protocol CombineNetworkController {
	func send <RQ: Request> (_ request: RQ) -> AnyPublisher<StandardResponse, ControllerError>
	func send <RQ: Request, RS: Response> (_ request: RQ, response: RS.Type) -> AnyPublisher<RS, ControllerError>
	func send <RQ: Request, RSM: ResponseModel> (_ request: RQ, responseModel: RSM.Type) -> AnyPublisher<StandardModelResponse<RSM>, ControllerError>
}
