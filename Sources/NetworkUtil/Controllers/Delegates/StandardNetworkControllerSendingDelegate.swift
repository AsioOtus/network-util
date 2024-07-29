public struct StandardNetworkControllerSendingDelegate <RQ: Request, RSM: Decodable>: NetworkControllerSendingDelegate {
	public let encoding: Encoding<RQ>?
	public let decoding: Decoding<RSM>?
	public let urlRequestInterception: URLRequestInterception?
	public let urlResponseInterception: URLResponseInterception?
	public let sending: Sending<RQ>?

	public init (
		encoding: Encoding<RQ>? = nil,
		decoding: Decoding<RSM>? = nil,
		urlRequestInterception: URLRequestInterception? = nil,
		urlResponseInterception: URLResponseInterception? = nil,
		sending: Sending<RQ>? = nil
	) {
		self.encoding = encoding
		self.decoding = decoding
		self.urlRequestInterception = urlRequestInterception
		self.urlResponseInterception = urlResponseInterception
		self.sending = sending
	}
}

public extension NetworkControllerSendingDelegate {
	static func delegate <RQ: Request, RSM: Decodable> (
		encoding: Encoding<RQ>? = nil,
		decoding: Decoding<RSM>? = nil,
		urlRequestInterception: URLRequestInterception? = nil,
		urlResponseInterception: URLResponseInterception? = nil,
		sending: Sending<RQ>? = nil
	) -> Self where Self == StandardNetworkControllerSendingDelegate<RQ, RSM> {
		.init(
			encoding: encoding,
			decoding: decoding,
			urlRequestInterception: urlRequestInterception,
			urlResponseInterception: urlResponseInterception,
			sending: sending
		)
	}

	static func empty <RQ: Request, RSM: Decodable> (
	) -> Self where Self == StandardNetworkControllerSendingDelegate<RQ, RSM> {
		.init()
	}
}
