import Foundation

public struct ErrorDecorator: APIClientDecorator {
	public let apiClient: APIClient

	public let error: Error?

	public init (
		error: Error?,
		apiClient: APIClient
	) {
		self.error = error
		self.apiClient = apiClient
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
        response: RS.Type,
		delegate: some APIClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS {
		if let error { throw error }

        return try await apiClient.send(
			request,
			response: response,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}
}

public extension APIClient {
	func error (_ error: Error?) -> ErrorDecorator {
		.init(error: error, apiClient: self)
	}
}
