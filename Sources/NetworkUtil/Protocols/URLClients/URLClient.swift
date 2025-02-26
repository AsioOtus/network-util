import Foundation

public protocol URLClient {
	var logPublisher: LogPublisher { get }
	var logs: AsyncStream<LogRecord> { get }

	var configuration: RequestConfiguration { get }
	var delegate: URLClientDelegate { get }

	func updateConfiguration (_ update: RequestConfiguration.Update) -> URLClient
	func configuration (_ configuration: RequestConfiguration) -> URLClient
	func delegate (_ delegate: URLClientDelegate) -> URLClient

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some URLClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS

	func send <RQ: Request> (
		_ request: RQ,
		delegate: some URLClientSendingDelegate<RQ, StandardResponse<Data>.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> StandardResponse<Data>

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		delegate: some URLClientSendingDelegate<RQ, RSM>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> StandardResponse<RSM>
}

public extension URLClient {
	func send <RQ: Request> (
		_ request: RQ,
		delegate: some URLClientSendingDelegate<RQ, StandardResponse<Data>.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> StandardResponse<Data> {
		try await send(
			request,
			response: StandardResponse<Data>.self,
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
			response: StandardResponse<Data>.self,
			delegate: .empty(),
			configurationUpdate: configurationUpdate
		)
	}

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		delegate: some URLClientSendingDelegate<RQ, RSM>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> StandardResponse<RSM> {
		try await send(
			request,
			response: StandardResponse<RSM>.self,
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
			response: StandardResponse<RSM>.self,
			delegate: .empty(),
			configurationUpdate: configurationUpdate
		)
	}
}
