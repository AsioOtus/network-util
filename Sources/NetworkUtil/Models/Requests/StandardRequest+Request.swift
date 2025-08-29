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

public extension Request {
    static func get (
        name: String = .init(describing: Self.self),
        path: String,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            name: name,
            body: nil,
            configuration: .init().method(.get).path(path).merge(into: configuration),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func get (
        name: String = .init(describing: Self.self),
        _ address: String? = nil,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            name: name,
            body: nil,
            configuration: .init().method(.get).address(address).merge(into: configuration),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func post (
        name: String = .init(describing: Self.self),
        body: Body? = nil,
        path: String,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            name: name,
            body: body,
            configuration: .init().method(.post).path(path).merge(into: configuration),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func post <B> (
        name: String = .init(describing: Self.self),
        _ address: String? = nil,
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body>,
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<B>
    where Self == StandardRequest<B>
    {
        .init(
            name: name,
            body: body,
            configuration: .init().method(.post).address(address).merge(into: configuration),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func post <B> (
        name: String = .init(describing: Self.self),
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<B>
    where Self == StandardRequest<B>
    {
        .init(
            name: name,
            body: body,
            configuration: .init().method(.post).merge(into: configuration),
            delegate: StandardRequestDelegate.empty(),
            configurationsMerging: configurationsMerging
        )
    }
}
