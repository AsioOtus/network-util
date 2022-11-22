import Foundation

public protocol AsyncNetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		interceptor: (some URLRequestInterceptor)?
	) async throws -> StandardResponse

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interceptor: (some URLRequestInterceptor)?
	) async throws -> RS

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interceptor: (some URLRequestInterceptor)?
	) async throws -> StandardModelResponse<RSM>

	func send <RQ: Request> (
		_ request: RQ,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) async throws -> StandardResponse

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) async throws -> RS

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		interception: @escaping (_ urlRequest: URLRequest) throws -> URLRequest
	) async throws -> StandardModelResponse<RSM>
}
