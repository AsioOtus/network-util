import Combine
import Foundation

public protocol APIClientDecorator: APIClient {
	var apiClient: APIClient { get }
}

public extension APIClientDecorator {
	var logPublisher: AnyPublisher<LogRecord, Never> {
		apiClient.logPublisher
	}

    var completionLogPublisher: AnyPublisher<CompletionLogRecord, Never> {
        apiClient.completionLogPublisher
    }

	var configuration: RequestConfiguration { apiClient.configuration }
	var delegate: APIClientDelegate { apiClient.delegate }

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some APIClientSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
		try await apiClient.send(
			request,
			response: response,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

    func requestEntities <RQ: Request, RS: Response> (
        _ request: RQ,
        response: RS.Type,
        delegate: some APIClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> (urlSession: URLSession, urlRequest: URLRequest, configuration: RequestConfiguration) {
        try await apiClient.requestEntities(
            request,
            response: response,
            delegate: delegate,
            configurationUpdate: configurationUpdate
        )
    }

	func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> APIClient {
		apiClient.configuration(update)
	}

	func setConfiguration (_ configuration: RequestConfiguration) -> APIClient {
		apiClient.setConfiguration(configuration)
	}

	func delegate (_ delegate: APIClientDelegate) -> APIClient {
		apiClient.delegate(delegate)
	}
}
