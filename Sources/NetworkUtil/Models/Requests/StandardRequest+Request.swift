import Foundation

public extension Request {
    static func standard <Body> (
        name: String = .init(describing: Self.self),
        _ address: String? = nil,
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
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func standard <Body> (
        name: String = .init(describing: Self.self),
        _ address: String? = nil,
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Body>
    where Self == StandardRequest<Body>
    {
        .init(
            name: name,
            address: address,
            body: body,
            configuration: configuration,
            delegate: StandardRequestDelegate.empty(),
            configurationsMerging: configurationsMerging
        )
    }

    static func standard (
        name: String = .init(describing: Self.self),
        _ address: String? = nil,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Data>,
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            name: name,
            address: address,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func standard (
        name: String = .init(describing: Self.self),
        _ address: String? = nil,
        configuration: RequestConfiguration = .init(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            name: name,
            address: address,
            configuration: configuration,
            delegate: StandardRequestDelegate.empty(),
            configurationsMerging: configurationsMerging
        )
    }

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
            address: nil,
            body: nil,
            configuration: configuration.merge(
                with: .init(method: .get)
                    .updateUrlComponents {
                        $0.path(path)
                    }
            ),
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
            address: address,
            body: nil,
            configuration: configuration.merge(with: .init(method: .get)),
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
            address: nil,
            body: body,
            configuration: configuration.merge(
                with: .init(method: .post)
                    .updateUrlComponents {
                        $0.path(path)
                    }
            ),
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
            address: address,
            body: body,
            configuration: .init(method: .post).merge(with: configuration),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func post <B> (
        name: String = .init(describing: Self.self),
        _ address: String? = nil,
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        configurationsMerging: @escaping RequestConfiguration.Merging = defaultConfigurationMerging
    )
    -> StandardRequest<B>
    where Self == StandardRequest<B>
    {
        .init(
            name: name,
            address: address,
            body: body,
            configuration: .init(method: .post).merge(with: configuration),
            delegate: StandardRequestDelegate.empty(),
            configurationsMerging: configurationsMerging
        )
    }
}
