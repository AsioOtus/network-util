import Foundation

public struct StandardNetworkControllerSendingDelegate <RQ: Request, RSM: Decodable>: NetworkControllerSendingDelegate {
	public let encoding: Encoding<RQ.Body>?
	public let decoding: Decoding<RSM>?
	public let urlRequestInterceptions: [URLRequestInterception]
	public let urlResponseInterceptions: [URLResponseInterception]
	public let urlSessionTaskDelegate: URLSessionTaskDelegate?
	public let sending: Sending<RQ>?

	public init (
		encoding: Encoding<RQ.Body>? = nil,
		decoding: Decoding<RSM>? = nil,
		urlRequestInterception: URLRequestInterception? = nil,
		urlResponseInterception: URLResponseInterception? = nil,
		urlSessionTaskDelegate: URLSessionTaskDelegate? = nil,
		sending: Sending<RQ>? = nil
	) {
		self.encoding = encoding
		self.decoding = decoding
		self.urlRequestInterceptions = urlRequestInterception.map { [$0] } ?? []
		self.urlResponseInterceptions = urlResponseInterception.map { [$0] } ?? []
		self.urlSessionTaskDelegate = urlSessionTaskDelegate
		self.sending = sending
	}

	init (
		encoding: Encoding<RQ.Body>?,
		decoding: Decoding<RSM>?,
		urlRequestInterceptions: [URLRequestInterception],
		urlResponseInterceptions: [URLResponseInterception],
		urlSessionTaskDelegate: URLSessionTaskDelegate?,
		sending: Sending<RQ>?
	) {
		self.encoding = encoding
		self.decoding = decoding
		self.urlRequestInterceptions = urlRequestInterceptions
		self.urlResponseInterceptions = urlResponseInterceptions
		self.urlSessionTaskDelegate = urlSessionTaskDelegate
		self.sending = sending
	}
}

public extension StandardNetworkControllerSendingDelegate {
	func merge (with another: some NetworkControllerSendingDelegate<RQ, RSM>) -> Self where Self.RQ == RQ, Self.RSM == RSM {
		Self(
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
			}
		)
	}
}

public extension NetworkControllerSendingDelegate {
	static func standard <RQ: Request, RSM: Decodable> (
		encoding: Encoding<RQ.Body>? = nil,
		decoding: Decoding<RSM>? = nil,
		urlRequestInterception: URLRequestInterception? = nil,
		urlResponseInterception: URLResponseInterception? = nil,
		urlSessionTaskDelegate: URLSessionTaskDelegate? = nil,
		sending: Sending<RQ>? = nil
	) -> Self where Self == StandardNetworkControllerSendingDelegate<RQ, RSM> {
		.init(
			encoding: encoding,
			decoding: decoding,
			urlRequestInterception: urlRequestInterception,
			urlResponseInterception: urlResponseInterception,
			urlSessionTaskDelegate: urlSessionTaskDelegate,
			sending: sending
		)
	}

	static func empty <RQ: Request, RSM: Decodable> (
	) -> Self where Self == StandardNetworkControllerSendingDelegate<RQ, RSM> {
		.init()
	}
}
