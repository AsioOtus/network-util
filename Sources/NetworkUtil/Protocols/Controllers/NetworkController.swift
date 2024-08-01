import Foundation

public protocol NetworkController {
	var configuration: RequestConfiguration { get }

	func configuration (_ update: RequestConfiguration.Update) -> NetworkController
	func replace (configuration: RequestConfiguration) -> NetworkController

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		responseType: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS

	func send <RQ: Request> (
		_ request: RQ,
		delegate: some NetworkControllerSendingDelegate<RQ, StandardResponse<Data>.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> StandardResponse<Data>

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RSM>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> StandardResponse<RSM>
}

public extension NetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		delegate: some NetworkControllerSendingDelegate<RQ, StandardResponse<Data>.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
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
		configurationUpdate: RequestConfiguration.Update? = nil
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
		delegate: some NetworkControllerSendingDelegate<RQ, RSM>,
		configurationUpdate: RequestConfiguration.Update? = nil
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
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> StandardResponse<RSM> {
		try await send(
			request,
			responseType: StandardResponse<RSM>.self,
			delegate: .empty(),
			configurationUpdate: configurationUpdate
		)
	}

}
