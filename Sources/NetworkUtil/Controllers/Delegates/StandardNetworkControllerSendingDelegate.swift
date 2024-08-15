import Foundation

public struct StandardNetworkControllerSendingDelegate <RQ: Request, RSM: Decodable>: NetworkControllerSendingDelegate {
	public let encoding: Encoding<RQ.Body>?
	public let decoding: Decoding<RSM>?
	public let urlRequestInterception: URLRequestInterception?
	public let urlResponseInterception: URLResponseInterception?
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
		self.urlRequestInterception = urlRequestInterception
		self.urlResponseInterception = urlResponseInterception
		self.urlSessionTaskDelegate = urlSessionTaskDelegate
		self.sending = sending
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
