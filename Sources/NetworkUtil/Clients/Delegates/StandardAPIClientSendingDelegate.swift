import Foundation

public struct StandardAPIClientSendingDelegate <RQ: Request, RSM: Decodable>: APIClientSendingDelegate {
	public let id: UUIDGenerator?
	public let encoding: Encoding<RQ.Body>?
	public let decoding: Decoding<RSM>?
	public let urlRequestInterceptions: [URLRequestInterception]
	public let urlResponseInterceptions: [URLResponseInterception]
	public let urlSessionTaskDelegate: URLSessionTaskDelegate?
	public let sending: Sending<RQ>?
    public let responseModelPreparation: Preparation<RSM>?

	public init (
		id: UUIDGenerator? = nil,
		encoding: Encoding<RQ.Body>? = nil,
		decoding: Decoding<RSM>? = nil,
		urlRequestInterceptions: [URLRequestInterception],
		urlResponseInterceptions: [URLResponseInterception],
		urlSessionTaskDelegate: URLSessionTaskDelegate? = nil,
		sending: Sending<RQ>? = nil,
        responseModelPreparation: Preparation<RSM>? = nil
	) {
		self.id = id
		self.encoding = encoding
		self.decoding = decoding
		self.urlRequestInterceptions = urlRequestInterceptions
		self.urlResponseInterceptions = urlResponseInterceptions
		self.urlSessionTaskDelegate = urlSessionTaskDelegate
		self.sending = sending
        self.responseModelPreparation = responseModelPreparation
	}

    public init (
        id: UUIDGenerator? = nil,
        encoding: Encoding<RQ.Body>? = nil,
        decoding: Decoding<RSM>? = nil,
        urlRequestInterception: URLRequestInterception? = nil,
        urlResponseInterception: URLResponseInterception? = nil,
        urlSessionTaskDelegate: URLSessionTaskDelegate? = nil,
        sending: Sending<RQ>? = nil,
        responseModelPreparation: Preparation<RSM>? = nil
    ) {
        self.id = id
        self.encoding = encoding
        self.decoding = decoding
        self.urlRequestInterceptions = urlRequestInterception.map { [$0] } ?? []
        self.urlResponseInterceptions = urlResponseInterception.map { [$0] } ?? []
        self.urlSessionTaskDelegate = urlSessionTaskDelegate
        self.sending = sending
        self.responseModelPreparation = responseModelPreparation
    }
}

public extension StandardAPIClientSendingDelegate {
	func merge (with another: some APIClientSendingDelegate<RQ, RSM>) -> Self where Self.RQ == RQ, Self.RSM == RSM {
		Self(
			id: self.id ?? another.id,
			encoding: self.encoding ?? another.encoding,
			decoding: self.decoding ?? another.decoding,
			urlRequestInterceptions: another.urlRequestInterceptions + self.urlRequestInterceptions,
			urlResponseInterceptions: another.urlResponseInterceptions + self.urlResponseInterceptions,
			urlSessionTaskDelegate: self.urlSessionTaskDelegate ?? another.urlSessionTaskDelegate,
			sending: { sendingModel, sendingAction in
				try await (another.sending ?? emptySending())(sendingModel) { urlSession, urlRequest in
					try await (self.sending ?? emptySending())(
						.init(
							urlSession: urlSession,
							urlRequest: urlRequest,
							requestId: sendingModel.requestId,
							request: sendingModel.request,
							configuration: sendingModel.configuration
						),
						sendingAction
					)
				}
			},
            responseModelPreparation: {
                let anotherPreparedModel = try another.responseModelPreparation?($0) ?? $0
                let selfPreparedModel = try self.responseModelPreparation?(anotherPreparedModel) ?? anotherPreparedModel
                return selfPreparedModel
            }
		)
	}
}

public extension APIClientSendingDelegate {
	static func standard <RQ: Request, RSM: Decodable> (
		id: UUIDGenerator? = nil,
		encoding: Encoding<RQ.Body>? = nil,
		decoding: Decoding<RSM>? = nil,
		urlRequestInterceptions: [URLRequestInterception],
		urlResponseInterceptions: [URLResponseInterception],
		urlSessionTaskDelegate: URLSessionTaskDelegate? = nil,
		sending: Sending<RQ>? = nil,
        responseModelPreparation: Preparation<RSM>? = nil
	) -> Self where Self == StandardAPIClientSendingDelegate<RQ, RSM> {
		.init(
			id: id,
			encoding: encoding,
			decoding: decoding,
			urlRequestInterceptions: urlRequestInterceptions,
			urlResponseInterceptions: urlResponseInterceptions,
			urlSessionTaskDelegate: urlSessionTaskDelegate,
			sending: sending,
            responseModelPreparation: responseModelPreparation
		)
	}

    static func standard <RQ: Request, RSM: Decodable> (
        id: UUIDGenerator? = nil,
        encoding: Encoding<RQ.Body>? = nil,
        decoding: Decoding<RSM>? = nil,
        urlRequestInterceptions: URLRequestInterception? = nil,
        urlResponseInterceptions: URLResponseInterception? = nil,
        urlSessionTaskDelegate: URLSessionTaskDelegate? = nil,
        sending: Sending<RQ>? = nil,
        responseModelPreparation: Preparation<RSM>? = nil
    ) -> Self where Self == StandardAPIClientSendingDelegate<RQ, RSM> {
        .init(
            id: id,
            encoding: encoding,
            decoding: decoding,
            urlRequestInterceptions: urlRequestInterceptions.map { [$0] } ?? [],
            urlResponseInterceptions: urlResponseInterceptions.map { [$0] } ?? [],
            urlSessionTaskDelegate: urlSessionTaskDelegate,
            sending: sending,
            responseModelPreparation: responseModelPreparation
        )
    }

	static func empty <RQ: Request, RSM: Decodable> () -> Self where Self == StandardAPIClientSendingDelegate<RQ, RSM> {
		.init()
	}
}
