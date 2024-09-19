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

	func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> URLClient {
		urlClient.configuration(update)
	}

	func replace (configuration: RequestConfiguration) -> URLClient {
		urlClient.replace(configuration: configuration)
	}

	func delegate (_ delegate: URLClientDelegate) -> URLClient {
		urlClient.delegate(delegate)
	}
}
