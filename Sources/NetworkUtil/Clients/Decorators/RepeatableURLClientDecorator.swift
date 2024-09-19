import Foundation

public struct RepeatableURLClientDecorator: URLClientDecorator {
	public typealias DelayStrategy = (Int) -> Int
	public typealias ErrorHandler = (Error, Int, Int?) throws -> Void

	public let maxAttempts: Int?
	public let delayStrategy: DelayStrategy?
	public let errorHandler: ErrorHandler?

	public let urlClient: URLClient

	public init (
		maxAttempts: Int?,
		urlClient: URLClient,
		delayStrategy: DelayStrategy? = nil,
		errorHandler: ErrorHandler? = nil
	) {
		self.maxAttempts = maxAttempts
		self.urlClient = urlClient
		self.delayStrategy = delayStrategy
		self.errorHandler = errorHandler
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some URLClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS {
		try await urlClient.send(
			request,
			response: response,
			delegate: .standard(sending: self.sending).merge(with: delegate),
			configurationUpdate: configurationUpdate
		)
	}

	func sending <RQ: Request> (
		_ sendingModel: SendingModel<RQ>,
		_ sendingAction: SendAction<RQ>
	) async throws -> (Data, URLResponse) {
		let maxAttempts = (sendingModel.configuration.info[.repeatAttemptCount] as? Int) ?? maxAttempts
		var attempts = 0

		repeat {
			do {
				let (data, urlResponse) = try await sendingAction(sendingModel.urlSession, sendingModel.urlRequest)
				return (data, urlResponse)
			} catch {
				if let maxAttempts, attempts == maxAttempts - 1 {
					throw error
				}

				try errorHandler?(error, attempts, maxAttempts)

				try await Task.sleep(nanoseconds: delayInNanoseconds(attempts))
				attempts += 1
			}
		} while true
	}

	func delayInNanoseconds (_ attemptCount: Int) -> UInt64 {
		UInt64(delayStrategy?(attemptCount) ?? 0) * NSEC_PER_SEC
	}
}

public extension RequestConfiguration.InfoKey {
	static var repeatAttemptCount: Self {
		"infoKey.RepeatableURLClientDecorator.repeatAttemptCount"
	}
}

public extension URLClient {
	func repeatable (
		maxAttempts: Int?,
		delayStrategy: RepeatableURLClientDecorator.DelayStrategy? = nil,
		errorHandler: RepeatableURLClientDecorator.ErrorHandler? = nil
	) -> RepeatableURLClientDecorator {
		RepeatableURLClientDecorator(
			maxAttempts: maxAttempts,
			urlClient: self,
			delayStrategy: delayStrategy,
			errorHandler: errorHandler
		)
	}
}
