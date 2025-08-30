import Foundation

public extension RequestConfiguration {
    func method (_ method: Method?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setUrlComponents (_ urlComponents: URLComponents) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func urlComponents (_ update: (URLComponents) -> URLComponents) -> Self {
        setUrlComponents(update(urlComponents))
    }

    func address (_ address: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setHeaders (_ headers: Headers) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setHeader (key: String, value: String) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: [key: value],
            timeout: timeout,
            info: info
        )
    }

    func headers (_ headers: Headers) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: self.headers.merging(headers) { $1 },
            timeout: timeout,
            info: info
        )
    }

    func header (key: String, value: String) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: self.headers.merging([key: value]) { $1 },
            timeout: timeout,
            info: info
        )
    }

    func setInfo (_ info: Info) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setInfo (key: InfoKey, value: AnyHashable) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: headers,
            timeout: timeout,
            info: [key: value]
        )
    }

    func info (_ info: Info) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: headers,
            timeout: timeout,
            info: self.info.merging(info) { $1 }
        )
    }

    func info (key: InfoKey, value: AnyHashable) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
            headers: headers,
            timeout: timeout,
            info: self.info.merging([key: value]) { $1 }
        )
    }

    func timeout (_ timeout: Double?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents,
            address: address,
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
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func user (_ user: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.user(user),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func password (_ password: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.password(password),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setHost (_ host: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setHost(host),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func host (_ host: String, raw: Bool = false) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.host(host, raw: raw),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func port (_ port: Int?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.port(port),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setPath (_ path: String, raw: Bool = false) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setPath(path, raw: raw),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func path (_ path: String, raw: Bool = false) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.path(path, raw: raw),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setQueryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setQueryItems(queryItems),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func setQueryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.setQueryItem(queryItem),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func queryItems (_ queryItems: [URLQueryItem]) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.queryItems(queryItems),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func queryItem (_ queryItem: URLQueryItem) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.queryItem(queryItem),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }

    func fragment (_ fragment: String?) -> Self {
        .init(
            method: method,
            urlComponents: urlComponents.fragment(fragment),
            address: address,
            headers: headers,
            timeout: timeout,
            info: info
        )
    }
}
