import Combine
import Foundation

public protocol URLClient {
	var logPublisher: AnyPublisher<LogRecord, Never> { get }

	var configuration: RequestConfiguration { get }
	var delegate: URLClientDelegate { get }

	func configuration (_ update: RequestConfiguration.Update) -> URLClient
	func setConfiguration (_ configuration: RequestConfiguration) -> URLClient
	func delegate (_ delegate: URLClientDelegate) -> URLClient

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some URLClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS

    func requestEntities <RQ: Request, RS: Response> (
        _ request: RQ,
        response: RS.Type,
        delegate: some URLClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> (urlSession: URLSession, urlRequest: URLRequest, configuration: RequestConfiguration)
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
}

public extension URLClient {
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

public extension URLClient {
    func send <RQ: RequestWithResponseModel> (
        _ request: RQ,
        delegate: some URLClientSendingDelegate<RQ, RQ.RSM>,
        configurationUpdate: RequestConfiguration.Update? = nil
    ) async throws -> StandardResponse<RQ.RSM> {
        try await send(
            request,
            response: StandardResponse<RQ.RSM>.self,
            delegate: delegate,
            configurationUpdate: configurationUpdate
        )
    }

    func send <RQ: RequestWithResponseModel> (
        _ request: RQ,
        configurationUpdate: RequestConfiguration.Update? = nil
    ) async throws -> StandardResponse<RQ.RSM> {
        try await send(
            request,
            response: StandardResponse<RQ.RSM>.self,
            delegate: .empty(),
            configurationUpdate: configurationUpdate
        )
    }
}

public extension URLClient {
    func send <RQ: RequestWithResponse> (
        _ request: RQ,
        delegate: some URLClientSendingDelegate<RQ, RQ.RS.Model>,
        configurationUpdate: RequestConfiguration.Update? = nil
    ) async throws -> RQ.RS {
        try await send(
            request,
            response: RQ.RS.self,
            delegate: delegate,
            configurationUpdate: configurationUpdate
        )
    }

    func send <RQ: RequestWithResponse> (
        _ request: RQ,
        configurationUpdate: RequestConfiguration.Update? = nil
    ) async throws -> RQ.RS {
        try await send(
            request,
            response: RQ.RS.self,
            delegate: .empty(),
            configurationUpdate: configurationUpdate
        )
    }
}
