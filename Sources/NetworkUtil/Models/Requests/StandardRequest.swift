import Foundation

public struct StandardRequest <Body: Encodable>: Request {
    public let name: String
	public let address: String?
	public let body: Body?
	public let configuration: RequestConfiguration
	public let delegate: any RequestDelegate<Body>
    public var configurationsMerging: RequestConfiguration.Merging

	public init (
        name: String = .init(describing: Self.self),
		address: String? = nil,
		body: Body? = nil,
		configuration: RequestConfiguration = .init(),
		delegate: any RequestDelegate<Body> = StandardRequestDelegate.empty(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
	) {
        self.name = name
		self.address = address
		self.body = body
		self.configuration = configuration
		self.delegate = delegate
		self.configurationsMerging = configurationsMerging
	}

	public init (
        name: String = .init(describing: Self.self),
		address: String? = nil,
		configuration: RequestConfiguration = .init(),
		delegate: any RequestDelegate<Body> = StandardRequestDelegate.empty(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
	) where Body == Data {
        self.name = name
		self.address = address
		self.body = nil
		self.configuration = configuration
		self.delegate = delegate
		self.configurationsMerging = configurationsMerging
	}

	public func mergeConfiguration (with configuration: RequestConfiguration) -> RequestConfiguration {
        configurationsMerging(self.configuration, configuration)
	}
}

public func defaultConfigurationMerging (_ lhs: RequestConfiguration, _ rhs: RequestConfiguration) -> RequestConfiguration {
    lhs.merge(with: rhs)
}
