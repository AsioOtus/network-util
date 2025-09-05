import Combine
import Foundation
import NetworkUtil

public enum StubAPIClientError: Error {
    case stubNotFound
    case stubHasUnexpectedType
}

public final class StubAPIClient: APIClient {
    public var configuration: RequestConfiguration
    public var delegate: any APIClientDelegate

    public var logPublisher: AnyPublisher<LogRecord, Never> { Empty().eraseToAnyPublisher() }
    public var completionLogPublisher: AnyPublisher<CompletionLogRecord, Never> { Empty().eraseToAnyPublisher() }

    public var responses: [String: any Response] = [:]

    public init (
        configuration: RequestConfiguration = .init(),
        delegate: APIClientDelegate = .standard()
    ) {
        self.configuration = configuration
        self.delegate = delegate
    }

    public func send<RQ: Request, RS: Response>(
        _ request: RQ,
        response: RS.Type,
        delegate: some APIClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> RS where RS: Response {
        guard let response = responses[request.name]
        else { throw StubAPIClientError.stubNotFound }

        guard let response = response as? RS
        else { throw StubAPIClientError.stubHasUnexpectedType }

        return response
    }

    public func requestEntities <RQ, RS> (
        _ request: RQ,
        response: RS.Type,
        delegate: some APIClientSendingDelegate,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> (
        urlSession: URLSession,
        urlRequest: URLRequest,
        configuration: RequestConfiguration
    ) where RS : Response {
        fatalError()
    }

    public func configuration (_ update: (RequestConfiguration) -> RequestConfiguration) -> any APIClient {
        configuration = update(configuration)
        return self
    }

    public func setConfiguration (_ configuration: RequestConfiguration) -> any APIClient {
        self.configuration = configuration
        return self
    }

    public func delegate (_ delegate: any APIClientDelegate) -> any APIClient {
        self.delegate = delegate
        return self
    }
}

public extension StubAPIClient {
    func response (for requestName: String, _ response: some Response) -> Self {
        responses[requestName] = response
        return self
    }

    func responseModel (for requestName: String, _ responseModel: some Decodable) -> Self {
        responses[requestName] = StandardResponse(data: .init(), urlResponse: .init(), model: responseModel)
        return self
    }
}
