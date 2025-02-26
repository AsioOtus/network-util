import Foundation

public extension RequestConfiguration {
    func method (_ method: Method) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func urlComponents (_ urlComponents: URLComponents) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func headers (_ headers: Headers) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func header (key: String, value: String) -> Self {
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

    func info (_ info: Info) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func info (key: InfoKey, value: AnyHashable) -> Self {
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

    func timeout (_ timeout: Double) -> Self {
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
    func scheme (_ scheme: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.scheme(scheme),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func user (_ user: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.user(user),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func password (_ password: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.password(password),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func host (_ host: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.host(host),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func port (_ port: Int?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.port(port),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func path (_ path: String) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.path(path),
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

    func queryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.queryItems(queryItems),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func queryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.queryItem(queryItem),
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

    func fragment (_ fragment: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.fragment(fragment),
            headers: headers,
            timeout: timeout,
            info: info
        )
    }
}

public extension RequestConfiguration {
    func updateUrlComponents (_ update: (URLComponents) -> URLComponents) -> Self {
        urlComponents(update(urlComponents))
    }
}
