import Foundation

public struct SendingModel<RQ: Request> {
	public let urlSession: URLSession
	public let urlRequest: URLRequest
	public let requestId: UUID
	public let request: RQ
	public let configuration: RequestConfiguration

	public init (
		urlSession: URLSession,
		urlRequest: URLRequest,
		requestId: UUID,
		request: RQ,
		configuration: RequestConfiguration
	) {
		self.urlSession = urlSession
		self.urlRequest = urlRequest
		self.requestId = requestId
		self.request = request
		self.configuration = configuration
	}
}

public struct AnySendingModel {
	public let urlSession: URLSession
	public let urlRequest: URLRequest
	public let requestId: UUID
	public let request: any Request
	public let configuration: RequestConfiguration

	public init (
		urlSession: URLSession,
		urlRequest: URLRequest,
		requestId: UUID,
		request: any Request,
		configuration: RequestConfiguration
	) {
		self.urlSession = urlSession
		self.urlRequest = urlRequest
		self.requestId = requestId
		self.request = request
		self.configuration = configuration
	}
}

public typealias SendAction<RQ: Request> = (URLSession, URLRequest) async throws -> (Data, URLResponse)

public typealias Sending<RQ: Request> = (SendingModel<RQ>, SendAction<RQ>) async throws -> (Data, URLResponse)

public typealias AnySendAction = (URLSession, URLRequest) async throws -> (Data, URLResponse)

public typealias AnySending = (AnySendingModel, AnySendAction) async throws -> (Data, URLResponse)

public func emptySending <RQ: Request> () -> Sending<RQ> {
	{ try await $1($0.urlSession, $0.urlRequest) }
}

public func emptyAnySending () -> AnySending {
	{ try await $1($0.urlSession, $0.urlRequest) }
}

public func mockSending <RQ: Request> (
	data: Data = .init(),
	urlResponse: URLResponse = .init(),
	action: @escaping () -> Void = { }
) -> Sending<RQ> {
	{ _, _ in
		action()
		return (data, urlResponse)
	}
}

public func mockSending <RQ: Request> (
	data: Data = .init(),
	urlResponse: URLResponse = .init(),
	action: @escaping (URLRequest) -> Void
) -> Sending<RQ> {
	{ sendActionModel, _ in
		action(sendActionModel.urlRequest)
		return (data, urlResponse)
	}
}
