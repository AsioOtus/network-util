import Foundation

public struct ErrorDecorator: URLClientDecorator {
	public let urlClient: URLClient

	public let error: Error?

	public init (
		error: Error?,
		urlClient: URLClient
	) {
		self.error = error
		self.urlClient = urlClient
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
        response: RS.Type,
		delegate: some URLClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS {
		if let error { throw error }

        return try await urlClient.send(
			request,
			response: response,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}
}

public extension URLClient {
	func error (_ error: Error?) -> ErrorDecorator {
		.init(error: error, urlClient: self)
	}
}
