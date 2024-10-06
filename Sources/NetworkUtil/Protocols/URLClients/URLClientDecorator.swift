import Foundation

public protocol URLClientDecorator: URLClient {
	var urlClient: URLClient { get }
}

public extension URLClientDecorator {
	var logPublisher: LogPublisher {
		urlClient.logPublisher
	}

	var logs: AsyncStream<LogRecord> {
		urlClient.logs
	}

	var configuration: RequestConfiguration { urlClient.configuration }
	var delegate: URLClientDelegate { urlClient.delegate }

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some URLClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
		try await urlClient.send(
			request,
			response: response,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	func configuration (update: (RequestConfiguration) -> RequestConfiguration) -> URLClient {
		urlClient.configuration(update: update)
	}

	func setConfiguration (_ configuration: RequestConfiguration) -> URLClient {
		urlClient.setConfiguration(configuration)
	}

	func setDelegate (_ delegate: URLClientDelegate) -> URLClient {
		urlClient.setDelegate(delegate)
	}
}
