public struct StandardNetworkControllerSendingDelegate <RQ: Request, RS: Response>: NetworkControllerSendingDelegate {
	public let encoding: Encoding<RQ>?
	public let decoding: Decoding<RS>?
	public let urlRequestInterception: URLRequestInterception?
	public let urlResponseInterception: URLResponseInterception?
	public let sending: Sending<RQ>?

	public init (
		encoding: Encoding<RQ>? = nil,
		decoding: Decoding<RS>? = nil,
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
	static func delegate <RQ: Request, RS: Response> (
		encoding: Encoding<RQ>? = nil,
		decoding: Decoding<RS>? = nil,
		urlRequestInterception: URLRequestInterception? = nil,
		urlResponseInterception: URLResponseInterception? = nil,
		sending: Sending<RQ>? = nil
	) -> Self where Self == StandardNetworkControllerSendingDelegate<RQ, RS> {
		.init(
			encoding: encoding,
			decoding: decoding,
			urlRequestInterception: urlRequestInterception,
			urlResponseInterception: urlResponseInterception,
			sending: sending
		)
	}

	static func empty <RQ: Request, RS: Response> (
	) -> Self where Self == StandardNetworkControllerSendingDelegate<RQ, RS> {
		.init()
	}
}
