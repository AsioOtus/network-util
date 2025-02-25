import Foundation

public extension RequestConfiguration {
    func setMethod (_ method: Method) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setUrlComponents (_ urlComponents: URLComponents) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setHeaders (_ headers: Headers) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setHeader (key: String, value: String) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: [key: value],
            timeout: timeout,
            info: info
        )
    }

    func addHeaders (_ headers: Headers) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: self.headers.merging(headers) { $1 },
            timeout: timeout,
            info: info
        )
    }

    func addHeader (key: String, value: String) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: self.headers.merging([key: value]) { $1 },
            timeout: timeout,
            info: info
        )
    }

    func setInfo (_ info: Info) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setInfo (key: InfoKey, value: AnyHashable) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: [key: value]
        )
    }

    func addInfo (_ info: Info) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: self.info.merging(info) { $1 }
        )
    }

    func addInfo (key: InfoKey, value: AnyHashable) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: self.info.merging([key: value]) { $1 }
        )
    }

    func setTimeout (_ timeout: Double) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }
}

public extension RequestConfiguration {
    func setScheme (_ scheme: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setScheme(scheme),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setUser (_ user: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setUser(user),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setPassword (_ password: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setPassword(password),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setHost (_ host: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setHost(host),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setPort (_ port: Int?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setPort(port),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setPath (_ path: String) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setPath(path),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func addPath (_ path: String) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.addPath(path),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setQueryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setQueryItems(queryItems),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setQueryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setQueryItem(queryItem),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func addQueryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.addQueryItems(queryItems),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func addQueryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.addQueryItem(queryItem),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setFragment (_ fragment: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setFragment(fragment),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }
}

public extension RequestConfiguration {
    func updateUrlComponents (_ update: (URLComponents) -> URLComponents) -> Self {
        setUrlComponents(update(urlComponents))
    }
}
