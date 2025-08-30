import Foundation
import Testing

@testable import NetworkUtil

@Suite("StandardRequest – constructors")
struct StandardRequest_RequestConstructors_ConfigurationTests {
    @Test(".get with path – creates configuration with .get and path")
    func get_path () {
        let request = StandardRequest<Data>.get(path: "path")

        #expect(
            request.configuration == .init(
                method: .get,
                urlComponents: .init(path: "/path")
            )
        )
    }

    @Test(".get with path – append path")
    func get_path_appendPath () {
        let request = StandardRequest<Data>.get(path: "path", configuration: .init(urlComponents: .init(path: "path-2")))

        #expect(
            request.configuration == .init(
                method: .get,
                urlComponents: .init(path: "/path/path-2")
            )
        )
    }

    @Test(".get with path – overrides method value")
    func get_path_overridesMethod () {
        let request = StandardRequest<Data>.get(path: "path", configuration: .init(method: .post))

        #expect(
            request.configuration == .init(
                method: .post,
                urlComponents: .init(path: "/path")
            )
        )
    }

    @Test(".get with address – creates configuration with .get and address")
    func get_address () {
        let request = StandardRequest<Data>.get("site.com")

        #expect(
            request.configuration == .init(
                method: .get,
                address: "site.com"
            )
        )
    }

    @Test(".get with address – overrides address")
    func get_address_overridesAddress () {
        let request = StandardRequest<Data>.get("site.com", configuration: .init(address: "another.net"))

        #expect(
            request.configuration == .init(
                method: .get,
                address: "another.net"
            )
        )
    }

    @Test(".get with address – overrides method value")
    func get_address_overridesMethod () {
        let request = StandardRequest<Data>.get(configuration: .init(method: .post))

        #expect(request.configuration == .init(method: .post))
    }

    @Test(".post with path – creates configuration with .get and path")
    func post_path () {
        let request = StandardRequest<Data>.post(path: "path")

        #expect(
            request.configuration == .init(
                method: .post,
                urlComponents: .init(path: "/path")
            )
        )
    }

    @Test(".post with path – append path")
    func post_path_appendPath () {
        let request = StandardRequest<Data>.post(path: "path", configuration: .init(urlComponents: .init(path: "path-2")))

        #expect(
            request.configuration == .init(
                method: .post,
                urlComponents: .init(path: "/path/path-2")
            )
        )
    }

    @Test(".post with path – overrides method value")
    func post_path_overridesMethod () {
        let request = StandardRequest<Data>.post(path: "path", configuration: .init(method: .get))

        #expect(
            request.configuration == .init(
                method: .get,
                urlComponents: .init(path: "/path")
            )
        )
    }

    @Test(".post with address – creates configuration with .get and address")
    func post_address () {
        let request = StandardRequest<Data>.post("site.com")

        #expect(
            request.configuration == .init(
                method: .post,
                address: "site.com"
            )
        )
    }

    @Test(".post with address – overrides address")
    func post_address_overridesAddress () {
        let request = StandardRequest<Data>.post("site.com", configuration: .init(address: "another.net"))

        #expect(
            request.configuration == .init(
                method: .post,
                address: "another.net"
            )
        )
    }

    @Test(".post with address and delegate – overrides method value")
    func post_address_overridesMethod () {
        let request = StandardRequest<Data>.post(configuration: .init(method: .get))

        #expect(request.configuration == .init(method: .get))
    }

    @Test(".post with address and delegate – creates configuration with .get and address")
    func post_address_withDelegate () {
        let request = StandardRequest<Data>.post(
            "site.com",
            delegate: .standard()
        )

        #expect(
            request.configuration == .init(
                method: .post,
                address: "site.com"
            )
        )
    }

    @Test(".post with address and delegate – overrides address")
    func post_address_overridesAddress_withDelegate () {
        let request = StandardRequest<Data>.post(
            "site.com",
            configuration: .init(address: "another.net"),
            delegate: .standard()
        )

        #expect(
            request.configuration == .init(
                method: .post,
                address: "another.net"
            )
        )
    }

    @Test(".post with address and delegate – overrides method value")
    func post_address_overridesMethod_withDelegate () {
        let request = StandardRequest<Data>.post(
            configuration: .init(method: .get),
            delegate: .standard()
        )

        #expect(request.configuration == .init(method: .get))
    }
}
