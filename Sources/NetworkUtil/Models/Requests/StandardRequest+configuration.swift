import Foundation

public extension StandardRequest {
    func setAddress (_ address: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setBody (_ body: Body?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setConfiguration (_ configuration: RequestConfiguration) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setDelegate (_ delegate: any RequestDelegate<Body>) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration,
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setConfigurationsMerging (_ configurationsMerging: @escaping RequestConfiguration.Merging) -> Self {
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
    func setMethod (_ method: RequestConfiguration.Method) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setMethod(method),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setUrlComponents (_ urlComponents: URLComponents) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setUrlComponents(urlComponents),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setHeaders (_ headers: RequestConfiguration.Headers) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setHeaders(headers),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setHeader (key: String, value: String) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setHeader(key: key, value: value),
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

    func setInfo (_ info: RequestConfiguration.Info) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setInfo(info),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setInfo (key: RequestConfiguration.InfoKey, value: AnyHashable) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setInfo(key: key, value: value),
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

    func updateInfo (key: RequestConfiguration.InfoKey, value: AnyHashable) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.addInfo(key: key, value: value),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setTimeout (_ timeout: Double) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setTimeout(timeout),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }
}

public extension StandardRequest {
    func setScheme (_ scheme: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setScheme(scheme),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setUser (_ user: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setUser(user),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setPassword (_ password: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setPassword(password),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setHost (_ host: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setHost(host),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setPort (_ port: Int?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setPort(port),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setPath (_ path: String) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setPath(path),
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

    func setQueryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setQueryItems(queryItems),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }

    func setQueryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setQueryItem(queryItem),
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

    func setFragment (_ fragment: String?) -> Self {
        .init(
            address: address,
            body: body,
            configuration: configuration.setFragment(fragment),
            delegate: delegate,
            configurationsMerging: configurationsMerging
        )
    }
}

public extension StandardRequest {
    func updateConfiguration (_ update: @escaping RequestConfiguration.Update) -> Self {
        setConfiguration(update(configuration))
    }
}
