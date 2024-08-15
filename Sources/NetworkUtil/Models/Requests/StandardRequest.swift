import Foundation

public struct StandardRequest <Body: Encodable>: Request {
	public var address: String?
	public var body: Body?
	public var configuration: RequestConfiguration
	public var delegate: any RequestDelegate<Body>
	public var configurationUpdate: RequestConfiguration.Update

	public init (
		address: String? = nil,
		body: Body?,
		configuration: RequestConfiguration = .init(),
		delegate: any RequestDelegate<Body> = StandardRequestDelegate.empty(),
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	) {
		self.address = address
		self.body = body
		self.configuration = configuration
		self.delegate = delegate
		self.configurationUpdate = configurationUpdate
	}

	public init (
		address: String? = nil,
		configuration: RequestConfiguration = .init(),
		delegate: any RequestDelegate<Body> = StandardRequestDelegate.empty(),
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	) where Body == Data {
		self.address = address
		self.body = nil
		self.configuration = configuration
		self.delegate = delegate
		self.configurationUpdate = configurationUpdate
	}

	public func update (_ configuration: RequestConfiguration) -> RequestConfiguration {
		configurationUpdate(configuration)
	}
}

public extension StandardRequest {
	func setAddress (_ address: String?) -> Self {
		var copy = self
		copy.address = address
		return copy
	}

	func setBody (_ body: Body?) -> Self {
		var copy = self
		copy.body = body
		return copy
	}

	func setConfiguration (_ configuration: RequestConfiguration) -> Self {
		var copy = self
		copy.configuration = configuration
		return copy
	}

	func configuration (_ update: @escaping RequestConfiguration.Update) -> Self {
		var copy = self
		copy.configuration = copy.configuration.update(update)
		return copy
	}

	func setDelegate (_ delegate: any RequestDelegate<Body>) -> Self {
		var copy = self
		copy.delegate = delegate
		return copy
	}

	func setConfigurationUpdate (_ configurationUpdate: @escaping RequestConfiguration.Update) -> Self {
		var copy = self
		copy.configurationUpdate = configurationUpdate
		return copy
	}
}

public extension Request {
	static func request <B> (
		address: String? = nil,
		body: Body? = nil,
		configuration: RequestConfiguration = .init(),
		delegate: some RequestDelegate<Body>,
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	)
	-> StandardRequest<B>
	where Self == StandardRequest<B>
	{
		.init(
			address: address,
			body: body,
			configuration: configuration,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	static func request <B> (
		address: String? = nil,
		body: Body? = nil,
		configuration: RequestConfiguration = .init(),
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	)
	-> StandardRequest<B>
	where Self == StandardRequest<B>
	{
		.init(
			address: address,
			body: body,
			configuration: configuration,
			delegate: StandardRequestDelegate.empty(),
			configurationUpdate: configurationUpdate
		)
	}

	static func get (
		path: String,
		configuration: RequestConfiguration = .init(),
		delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	)
	-> StandardRequest<Data>
	where Self == StandardRequest<Data>
	{
		.init(
			address: nil,
			body: nil,
			configuration: configuration.merge(
				with: .init(method: .get)
					.url {
						$0.setPath(path)
					}
			),
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	static func get (
		_ address: String? = nil,
		configuration: RequestConfiguration = .init(),
		delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	)
	-> StandardRequest<Data>
	where Self == StandardRequest<Data>
	{
		.init(
			address: address,
			body: nil,
			configuration: configuration.merge(with: .init(method: .get)),
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	static func post (
		body: Body? = nil,
		path: String,
		configuration: RequestConfiguration = .init(),
		delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	)
	-> StandardRequest<Data>
	where Self == StandardRequest<Data>
	{
		.init(
			address: nil,
			body: body,
			configuration: configuration.merge(
				with: .init(method: .post)
					.url {
						$0.setPath(path)
					}
			),
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	static func post <B> (
		_ address: String? = nil,
		body: Body? = nil,
		configuration: RequestConfiguration = .init(),
		delegate: some RequestDelegate<Body>,
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	)
	-> StandardRequest<B>
	where Self == StandardRequest<B>
	{
		.init(
			address: address,
			body: body,
			configuration: .init(method: .post).merge(with: configuration),
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	static func post <B> (
		_ address: String? = nil,
		body: Body? = nil,
		configuration: RequestConfiguration = .init(),
		configurationUpdate: @escaping RequestConfiguration.Update = { $0 }
	)
	-> StandardRequest<B>
	where Self == StandardRequest<B>
	{
		.init(
			address: address,
			body: body,
			configuration: .init(method: .post).merge(with: configuration),
			delegate: StandardRequestDelegate.empty(),
			configurationUpdate: configurationUpdate
		)
	}
}
