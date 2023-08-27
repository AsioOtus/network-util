import Foundation

public protocol AsyncNetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interception: @escaping URLRequestInterception
	) async throws -> RS

	func send <RQ: Request> (
		_ request: RQ,
		interception: @escaping URLRequestInterception
	) async throws -> StandardResponse

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interception: @escaping URLRequestInterception
	) async throws -> StandardModelResponse<RSM>
}

public extension AsyncNetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> StandardResponse {
		try await send(request, response: StandardResponse.self, interception: interception)
	}

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> StandardModelResponse<RSM> {
		try await send(request, response: StandardModelResponse<RSM>.self, interception: interception)
	}
}
