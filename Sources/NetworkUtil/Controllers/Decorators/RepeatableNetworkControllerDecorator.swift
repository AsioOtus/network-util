import Foundation

public struct RepeatableNetworkControllerDecorator: NetworkControllerDecorator {
	public let maxAttempts: Int?
	public let delayStrategy: (Int) -> Int

	public let networkController: NetworkController

	public init (
		maxAttempts: Int?,
		delayStrategy: @escaping (Int) -> Int,
		networkController: NetworkController
	) {
		self.maxAttempts = maxAttempts
		self.delayStrategy = delayStrategy
		self.networkController = networkController
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS {
		try await networkController.send(
			request,
			response: response,
			delegate: .standard(
				encoding: delegate.encoding,
				decoding: delegate.decoding,
				urlRequestInterception: delegate.urlRequestInterception,
				urlResponseInterception: delegate.urlResponseInterception,
				sending: { urlSession, urlRequest, requestId, request, sendingAction in
					try await self.sending(urlSession, urlRequest, requestId, request) { urlSession, urlRequest, requestId, request in
						try await (delegate.sending ?? defaultSending())(urlSession, urlRequest, requestId, request, sendingAction)
					}
				}
			),
			configurationUpdate: configurationUpdate
		)
	}

	func sending <RQ: Request> (
		_ urlSession: URLSession,
		_ urlRequest: URLRequest,
		_ requestId: UUID,
		_ request: RQ,
		_ sendingAction: SendAction<RQ>
	) async throws -> (Data, URLResponse) {
		var attempts = 0

		repeat {
			do {
				let (data, urlResponse) = try await sendingAction(urlSession, urlRequest, requestId, request)
				return (data, urlResponse)
			} catch {
				if let maxAttempts, attempts == maxAttempts - 1 {
					throw error
				}
				try await Task.sleep(nanoseconds: delayInNanoseconds(attempts))
				attempts += 1
			}
		} while true
	}

	func delayInNanoseconds (_ attemptCount: Int) -> UInt64 {
		UInt64(delayStrategy(attemptCount)) * NSEC_PER_SEC
	}
}

public extension NetworkController {
	func repeatable (
		maxAttempts: Int?,
		delayStrategy: @escaping (Int) -> Int
	) -> RepeatableNetworkControllerDecorator {
		RepeatableNetworkControllerDecorator(
			maxAttempts: maxAttempts,
			delayStrategy: delayStrategy,
			networkController: self
		)
	}
}
