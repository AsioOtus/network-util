import Foundation

public extension Request {
    static func request <B> (
        address: String? = nil,
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body>,
        configurationsMerging: @escaping RequestConfiguration.Merging = Self.defaultConfigurationMerging
    )
    -> StandardRequest<B>
    where Self == StandardRequest<B>
    {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func request <B> (
        address: String? = nil,
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        configurationsMerging: @escaping RequestConfiguration.Merging = Self.defaultConfigurationMerging
    )
    -> StandardRequest<B>
    where Self == StandardRequest<B>
    {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: StandardRequestDelegate.empty(),
            configurationsMerging: configurationsMerging
        )
    }

    static func get (
        path: String,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
        configurationsMerging: @escaping RequestConfiguration.Merging = Self.defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            address: nil,
            body: nil,
            configuration: configuration.merge(
                with: .init(method: .get)
                    .updateUrlComponents {
                        $0.setPath(path)
                    }
            ),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func get (
        _ address: String? = nil,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
        configurationsMerging: @escaping RequestConfiguration.Merging = Self.defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            address: address,
            body: nil,
            configuration: configuration.merge(with: .init(method: .get)),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func post (
        body: Body? = nil,
        path: String,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body> = StandardRequestDelegate.empty(),
        configurationsMerging: @escaping RequestConfiguration.Merging = Self.defaultConfigurationMerging
    )
    -> StandardRequest<Data>
    where Self == StandardRequest<Data>
    {
        .init(
            address: nil,
            body: body,
            configuration: configuration.merge(
                with: .init(method: .post)
                    .updateUrlComponents {
                        $0.setPath(path)
                    }
            ),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func post <B> (
        _ address: String? = nil,
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        delegate: some RequestDelegate<Body>,
        configurationsMerging: @escaping RequestConfiguration.Merging = Self.defaultConfigurationMerging
    )
    -> StandardRequest<B>
    where Self == StandardRequest<B>
    {
        .init(
            address: address,
            body: body,
            configuration: .init(method: .post).merge(with: configuration),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    static func post <B> (
        _ address: String? = nil,
        body: Body? = nil,
        configuration: RequestConfiguration = .init(),
        configurationsMerging: @escaping RequestConfiguration.Merging = Self.defaultConfigurationMerging
    )
    -> StandardRequest<B>
    where Self == StandardRequest<B>
    {
        .init(
            address: address,
            body: body,
            configuration: .init(method: .post).merge(with: configuration),
            delegate: StandardRequestDelegate.empty(),
            configurationsMerging: configurationsMerging
        )
    }
}
