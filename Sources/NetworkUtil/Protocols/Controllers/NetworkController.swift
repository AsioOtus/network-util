import Foundation

public protocol NetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		responseType: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: URLRequestConfiguration.Update?
	) async throws -> RS

	func send <RQ: Request> (
		_ request: RQ,
		_ delegate: some NetworkControllerSendingDelegate<RQ, StandardResponse<Data>.Model>,
		configurationUpdate: URLRequestConfiguration.Update?
	) async throws -> StandardResponse<Data>

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		_ delegate: some NetworkControllerSendingDelegate<RQ, RSM>,
		configurationUpdate: URLRequestConfiguration.Update?
	) async throws -> StandardResponse<RSM>
}

public extension NetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		_ delegate: some NetworkControllerSendingDelegate<RQ, StandardResponse<Data>.Model>,
		configurationUpdate: URLRequestConfiguration.Update? = nil
	) async throws -> StandardResponse<Data> {
		try await send(
			request,
			responseType: StandardResponse<Data>.self,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	func send <RQ: Request> (
		_ request: RQ,
		configurationUpdate: URLRequestConfiguration.Update? = nil
	) async throws -> StandardResponse<Data> {
		try await send(
			request,
			responseType: StandardResponse<Data>.self,
			delegate: .empty(),
			configurationUpdate: configurationUpdate
		)
	}

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		_ delegate: some NetworkControllerSendingDelegate<RQ, RSM>,
		configurationUpdate: URLRequestConfiguration.Update? = nil
	) async throws -> StandardResponse<RSM> {
		try await send(
			request,
			responseType: StandardResponse<RSM>.self,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		configurationUpdate: URLRequestConfiguration.Update? = nil
	) async throws -> StandardResponse<RSM> {
		try await send(
			request,
			responseType: StandardResponse<RSM>.self,
			delegate: .empty(),
			configurationUpdate: configurationUpdate
		)
	}

}
