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
		Self(
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: urlRequestBuilder,
			encoder: encoder,
			decoder: decoder,
			urlRequestsInterceptions: urlRequestsInterceptions + [interception],
			urlResponsesInterceptions: urlResponsesInterceptions,
			sending: sending
		)
	}

	public func addUrlResponseInterception (_ interception: @escaping URLResponseInterception) -> NetworkControllerDelegate {
		Self(
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: urlRequestBuilder,
			encoder: encoder,
			decoder: decoder,
			urlRequestsInterceptions: urlRequestsInterceptions,
			urlResponsesInterceptions: urlResponsesInterceptions + [interception],
			sending: sending
		)
	}
}

public extension NetworkControllerDelegate where Self == StandardNetworkControllerDelegate {
	static func delegate (
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
}
