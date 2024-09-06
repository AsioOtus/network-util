import Foundation

public struct ErrorDecorator: NetworkControllerDecorator {
	public let networkController: NetworkController

	public let error: Error?

	public init (
		error: Error?,
		networkController: NetworkController
	) {
		self.error = error
		self.networkController = networkController
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS {
		if let error { throw error }

		return try await send(
			request,
			response: response,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}
}

public extension NetworkController {
	func error (_ error: Error?) -> ErrorDecorator {
		.init(error: error, networkController: self)
	}
}
