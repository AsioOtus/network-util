import Combine
import Foundation

public protocol URLClientDecorator: URLClient {
	var urlClient: URLClient { get }
}

public extension URLClientDecorator {
	var logPublisher: AnyPublisher<LogRecord, Never> {
		urlClient.logPublisher
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

    func requestEntities <RQ: Request, RS: Response> (
        _ request: RQ,
        response: RS.Type,
        delegate: some URLClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> (urlSession: URLSession, urlRequest: URLRequest, configuration: RequestConfiguration) {
        try await urlClient.requestEntities(
            request,
            response: response,
            delegate: delegate,
            configurationUpdate: configurationUpdate
        )
    }

	func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> URLClient {
		urlClient.configuration(update)
	}

	func setConfiguration (_ configuration: RequestConfiguration) -> URLClient {
		urlClient.setConfiguration(configuration)
	}

	func delegate (_ delegate: URLClientDelegate) -> URLClient {
		urlClient.delegate(delegate)
	}
}
