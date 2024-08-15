import Foundation

public struct StandardRequestDelegate <RQM: Encodable>: RequestDelegate {
	public let encoding: Encoding<RQM>?
	public let urlRequestInterception: URLRequestInterception?
	public let urlSessionTaskDelegate: URLSessionTaskDelegate?

	public init (
		encoding: Encoding<RQM>? = nil,
		urlRequestInterception: URLRequestInterception? = nil,
		urlSessionTaskDelegate: URLSessionTaskDelegate? = nil
	) {
		self.encoding = encoding
		self.urlRequestInterception = urlRequestInterception
		self.urlSessionTaskDelegate = urlSessionTaskDelegate
	}
}

public extension RequestDelegate {
	static func standard <RQM: Encodable> (
		encoding: Encoding<RQM>? = nil,
		urlRequestInterception: URLRequestInterception? = nil,
		urlSessionTaskDelegate: URLSessionTaskDelegate? = nil
	) -> Self where Self == StandardRequestDelegate<RQM> {
		.init(
			encoding: encoding,
			urlRequestInterception: urlRequestInterception,
			urlSessionTaskDelegate: urlSessionTaskDelegate
		)
	}

	static func empty <RQM: Encodable> () -> Self where Self == StandardRequestDelegate<RQM> {
		.init()
	}
}
