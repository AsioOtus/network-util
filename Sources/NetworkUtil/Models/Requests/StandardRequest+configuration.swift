import Foundation

public extension StandardRequest {
    func address (_ address: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func body (_ body: Body?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func configuration (_ configuration: RequestConfiguration) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func delegate (_ delegate: any RequestDelegate<Body>) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func configurationsMerging (_ configurationsMerging: @escaping RequestConfiguration.Merging) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }
}

public extension StandardRequest {
    func method (_ method: RequestConfiguration.Method) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.method(method),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func urlComponents (_ urlComponents: URLComponents) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.urlComponents(urlComponents),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func headers (_ headers: RequestConfiguration.Headers) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.headers(headers),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func header (key: String, value: String) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.header(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func addHeaders (_ headers: RequestConfiguration.Headers) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.addHeaders(headers),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func addHeader (key: String, value: String) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.addHeader(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func info (_ info: RequestConfiguration.Info) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.info(info),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func info (key: RequestConfiguration.InfoKey, value: AnyHashable) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.info(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func addInfo (_ info: RequestConfiguration.Info) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.addInfo(info),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func addInfo (key: RequestConfiguration.InfoKey, value: AnyHashable) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.addInfo(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func timeout (_ timeout: Double) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.timeout(timeout),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }
}

public extension StandardRequest {
    func scheme (_ scheme: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.scheme(scheme),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func user (_ user: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.user(user),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func password (_ password: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.password(password),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func host (_ host: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.host(host),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func port (_ port: Int?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.port(port),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func path (_ path: String) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.path(path),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func addPath (_ path: String) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.addPath(path),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func queryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.queryItems(queryItems),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func queryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.queryItem(queryItem),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func addQueryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.addQueryItems(queryItems),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func addQueryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.addQueryItem(queryItem),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func fragment (_ fragment: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.fragment(fragment),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }
}

public extension StandardRequest {
    func updateConfiguration (_ update: @escaping RequestConfiguration.Update) -> Self {
        configuration(update(configuration))
    }
}
