public struct StandardRequestDelegate <RQM: Encodable>: RequestDelegate {
	public let encoding: Encoding<RQM>?
	public let urlRequestInterception: URLRequestInterception?

	public init (
		encoding: Encoding<RQM>? = nil,
		urlRequestInterception: URLRequestInterception? = nil
	) {
		self.encoding = encoding
		self.urlRequestInterception = urlRequestInterception
	}
}

public extension RequestDelegate {
	static func delegate <RQM: Encodable> (
		encoding: Encoding<RQM>? = nil,
		urlRequestInterception: URLRequestInterception? = nil
	) -> Self where Self == StandardRequestDelegate<RQM> {
		.init(
			encoding: encoding,
			urlRequestInterception: urlRequestInterception
		)
	}
}
