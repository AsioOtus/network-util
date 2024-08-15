public struct StandardNetworkControllerDelegate: NetworkControllerDelegate {
	public var urlSessionBuilder: URLSessionBuilder?
	public var urlRequestBuilder: URLRequestBuilder?
	public var encoder: RequestBodyEncoder?
	public var decoder: ResponseModelDecoder?
	public var urlRequestsInterceptions: [URLRequestInterception]
	public var urlResponsesInterceptions: [URLResponseInterception]
	public var sending: SendingTypeErased?

	public init (
		urlSessionBuilder: URLSessionBuilder? = nil,
		urlRequestBuilder: URLRequestBuilder? = nil,
		encoder: RequestBodyEncoder? = nil,
		decoder: ResponseModelDecoder? = nil,
		urlRequestsInterceptions: [URLRequestInterception] = [],
		urlResponsesInterceptions: [URLResponseInterception] = [],
		sending: SendingTypeErased? = nil
	) {
		self.urlSessionBuilder = urlSessionBuilder
		self.urlRequestBuilder = urlRequestBuilder
		self.encoder = encoder
		self.decoder = decoder
		self.urlRequestsInterceptions = urlRequestsInterceptions
		self.urlResponsesInterceptions = urlResponsesInterceptions
		self.sending = sending
	}

	public func addUrlRequestInterception (_ interception: @escaping URLRequestInterception) -> NetworkControllerDelegate {
		var copy = self
		copy.urlRequestsInterceptions = [interception] + copy.urlRequestsInterceptions
		return copy
	}

	public func addUrlResponseInterception (_ interception: @escaping URLResponseInterception) -> NetworkControllerDelegate {
		var copy = self
		copy.urlResponsesInterceptions = [interception] + copy.urlResponsesInterceptions
		return copy
	}
}

public extension NetworkControllerDelegate where Self == StandardNetworkControllerDelegate {
	static func standard (
		urlSessionBuilder: URLSessionBuilder? = nil,
		urlRequestBuilder: URLRequestBuilder? = nil,
		encoder: RequestBodyEncoder? = nil,
		decoder: ResponseModelDecoder? = nil,
		urlRequestsInterceptions: [URLRequestInterception] = [],
		urlResponsesInterceptions: [URLResponseInterception] = [],
		sending: SendingTypeErased? = nil
	) -> Self {
		.init(
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: urlRequestBuilder,
			encoder: encoder,
			decoder: decoder,
			urlRequestsInterceptions: urlRequestsInterceptions,
			urlResponsesInterceptions: urlResponsesInterceptions,
			sending: sending
		)
	}

	static func empty () -> Self {
		.init()
	}
}
