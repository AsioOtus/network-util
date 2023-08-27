import Foundation

public protocol AsyncNetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interceptor: some URLRequestInterceptor
	) async throws -> RS

	func send <RQ: Request> (
		_ request: RQ,
		interceptor: some URLRequestInterceptor
	) async throws -> StandardResponse

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptor: some URLRequestInterceptor
	) async throws -> StandardModelResponse<RSM>
}

public extension AsyncNetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		interceptor: some URLRequestInterceptor
	) async throws -> StandardResponse {
		try await send(request, response: StandardResponse.self, interceptor: interceptor)
	}

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptor: some URLRequestInterceptor = .empty()
	) async throws -> StandardModelResponse<RSM> {
		try await send(request, response: StandardModelResponse<RSM>.self, interceptor: interceptor)
	}
}

public extension AsyncNetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) async throws -> RS {
		try await send(request, response: RS.self, interceptor: .compact(interception))
	}

	func send <RQ: Request> (
		_ request: RQ,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) async throws -> StandardResponse {
		try await send(request, response: StandardResponse.self, interception: interception)
	}

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) async throws -> StandardModelResponse<RSM> {
		try await send(request, response: StandardModelResponse<RSM>.self, interception: interception)
	}
}
