import Foundation

public extension StandardRequest {
    func name (_ name: String) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func body (_ body: Body?) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func configuration (_ configuration: RequestConfiguration) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func delegate (_ delegate: any RequestDelegate<Body>) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func configurationsMerging (_ configurationsMerging: @escaping RequestConfiguration.Merging) -> Self {
        .init(
            name: name,
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
            name: name,
            body: body,
            configuration: configuration.method(method),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setUrlComponents (_ urlComponents: URLComponents) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setUrlComponents(urlComponents),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func urlComponents (_ update: (URLComponents) -> URLComponents) -> Self {
        .init(
            configuration: configuration.urlComponents(update)
        )
    }

    func setHeaders (_ headers: RequestConfiguration.Headers) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setHeaders(headers),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setHeader (key: String, value: String) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setHeader(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func headers (_ headers: RequestConfiguration.Headers) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.headers(headers),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func header (key: String, value: String) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.header(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setInfo (_ info: RequestConfiguration.Info) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setInfo(info),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setInfo (key: RequestConfiguration.InfoKey, value: AnyHashable) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setInfo(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func info (_ info: RequestConfiguration.Info) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.info(info),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func info (key: RequestConfiguration.InfoKey, value: AnyHashable) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.info(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func timeout (_ timeout: Double) -> Self {
        .init(
            name: name,
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
            name: name,
            body: body,
            configuration: configuration.scheme(scheme),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func user (_ user: String?) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.user(user),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func password (_ password: String?) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.password(password),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setHost (_ host: String?) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setHost(host),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func host (_ host: String, raw: Bool = false) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.host(host, raw: raw),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func port (_ port: Int?) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.port(port),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setPath (_ path: String, raw: Bool = false) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setPath(path, raw: raw),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func path (_ path: String, raw: Bool = false) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.path(path, raw: raw),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setQueryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setQueryItems(queryItems),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setQueryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.setQueryItem(queryItem),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func queryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.queryItems(queryItems),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func queryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            name: name,
            body: body,
            configuration: configuration.queryItem(queryItem),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func fragment (_ fragment: String?) -> Self {
        .init(
            name: name,
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
