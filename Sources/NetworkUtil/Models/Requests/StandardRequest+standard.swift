import Foundation

public extension Request {
    static func standard <Body> (
        name: String = .init(describing: Self.self),
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body>,
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Body>
    where Self == StandardRequest<Body>
    {
        .init(
            name: name,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func standard <Body> (
        name: String = .init(describing: Self.self),
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Body>
    where Self == StandardRequest<Body>
    {
        .init(
            name: name,
            body: body,
            configuration: configuration,
            delegate: StandardRequestDelegate.empty(),
            configurationsMerging: configurationsMerging
        )
    }

    static func standard (
        name: String = .init(describing: Self.self),
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Data>,
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            name: name,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func standard (
        name: String = .init(describing: Self.self),
        configuration: RequestConfiguration = .init(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            name: name,
            configuration: configuration,
            delegate: StandardRequestDelegate.empty(),
            configurationsMerging: configurationsMerging
        )
    }
}
