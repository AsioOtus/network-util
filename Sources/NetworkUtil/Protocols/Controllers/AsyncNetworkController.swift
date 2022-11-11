public protocol AsyncNetworkController {
	func send <RQ: Request> (_ request: RQ) async throws -> StandardResponse
	func send <RQ: Request, RS: Response> (_ request: RQ, response: RS.Type) async throws -> RS
	func send <RQ: Request, RSM: ResponseModel> (_ request: RQ, responseModel: RSM.Type) async throws -> StandardModelResponse<RSM>
}
