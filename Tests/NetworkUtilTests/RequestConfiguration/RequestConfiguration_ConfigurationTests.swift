import Testing

@testable import NetworkUtil

@Suite("RequestConfiguration – configuration functions")
struct RequestConfiguration_ConfigurationTests {
    @Test
    func method () {
        var sut = RequestConfiguration()

        #expect(sut.method == nil)

        sut = sut.method(.get)
        #expect(sut == .init(method: "GET"))

        sut = sut.method(.post)
        #expect(sut == .init(method: "POST"))

        sut = sut.method(.put)
        #expect(sut == .init(method: "PUT"))

        sut = sut.method("TEST")
        #expect(sut == .init(method: "TEST"))

        sut = sut.method("test")
        #expect(sut == .init(method: "test"))

        sut = sut.method("")
        #expect(sut == .init(method: ""))

        sut = sut.method(nil)
        #expect(sut == .init(method: nil))
    }

    @Test
    func address () {
        var sut = RequestConfiguration()

        #expect(sut.address == nil)

        sut = sut.address("site.com")
        #expect(sut == .init(address: "site.com"))

        sut = sut.address("")
        #expect(sut == .init(address: ""))

        sut = sut.address(nil)
        #expect(sut == .init(address: nil))
    }

    @Test
    func setUrlComponents () {
        var sut = RequestConfiguration()

        #expect(sut.urlComponents == .init())

        sut = sut.setUrlComponents(.init(host: "site.com"))
        #expect(sut == .init(urlComponents: .init(host: "site.com")))
    }

    @Test
    func urlComponents () {
        var sut = RequestConfiguration()

        #expect(sut.urlComponents == .init())

        sut = sut.urlComponents {
            $0.setHost("site.com")
        }
        #expect(sut == .init(urlComponents: .init(host: "site.com")))
    }

    @Test
    func setHeaders () {
        var sut = RequestConfiguration()

        #expect(sut.headers == [:])

        sut = sut.setHeaders(["key1": "value1"])
        #expect(sut == .init(headers: ["key1": "value1"]))

        sut = sut.setHeaders([
            "key2": "value2",
            "key3": "value3",
        ])
        #expect(
            sut == .init(headers: [
                "key2": "value2",
                "key3": "value3",
            ])
        )

        sut = sut.setHeaders(["": ""])
        #expect(sut == .init(headers: ["": ""]))

        sut = sut.setHeaders([:])
        #expect(sut == .init(headers: [:]))
    }

    @Test
    func setHeader () {
        var sut = RequestConfiguration()

        #expect(sut.headers == [:])

        sut = sut.setHeader(key: "key1", value: "value1")
        #expect(sut == .init(headers: ["key1": "value1"]))

        sut = sut.setHeader(key: "key2", value: "value2")
        #expect(sut == .init(headers: ["key2": "value2"]))

        sut = sut.setHeader(key: "", value: "")
        #expect(sut == .init(headers: ["": ""]))
    }

    @Test
    func headers () {
        var sut = RequestConfiguration()

        #expect(sut.headers == [:])

        sut = sut.headers(["key1": "value1"])
        #expect(sut == .init(headers: ["key1": "value1"]))

        sut = sut.headers([
            "key2": "value2",
            "key3": "value3",
        ])
        #expect(
            sut == .init(headers: [
                "key1": "value1",
                "key2": "value2",
                "key3": "value3",
            ])
        )

        sut = sut.headers(["": ""])
        #expect(
            sut == .init(headers: [
                "key1": "value1",
                "key2": "value2",
                "key3": "value3",
                "": "",
            ])
        )

        sut = sut.headers([:])
        #expect(
            sut == .init(headers: [
                "key1": "value1",
                "key2": "value2",
                "key3": "value3",
                "": "",
            ])
        )
    }

    @Test
    func header () {
        var sut = RequestConfiguration()

        #expect(sut.headers == [:])

        sut = sut.header(key: "key1", value: "value1")
        #expect(sut == .init(headers: ["key1": "value1"]))

        sut = sut.header(key: "key2", value: "value2")
        #expect(
            sut == .init(headers: [
                "key1": "value1",
                "key2": "value2",
            ])
        )

        sut = sut.header(key: "", value: "")
        #expect(
            sut == .init(headers: [
                "key1": "value1",
                "key2": "value2",
                "": "",
            ])
        )
    }

    @Test
    func setInfo_multiple () {
        var sut = RequestConfiguration()

        #expect(sut.info == [:])

        sut = sut.setInfo(["key1": "value1"])
        #expect(sut == .init(info: ["key1": "value1"]))

        sut = sut.setInfo([
            "key2": "value2",
            "key3": "value3",
        ])
        #expect(
            sut == .init(info: [
                "key2": "value2",
                "key3": "value3",
            ])
        )

        sut = sut.setInfo(["": ""])
        #expect(sut == .init(info: ["": ""]))

        sut = sut.setInfo([:])
        #expect(sut == .init(info: [:]))
    }

    @Test
    func setInfo_single () {
        var sut = RequestConfiguration()

        #expect(sut.info == [:])

        sut = sut.setInfo(key: "key1", value: "value1")
        #expect(sut == .init(info: ["key1": "value1"]))

        sut = sut.setInfo(key: "key2", value: "value2")
        #expect(sut == .init(info: ["key2": "value2"]))

        sut = sut.setInfo(key: "", value: "")
        #expect(sut == .init(info: ["": ""]))
    }

    @Test
    func info_multiple () {
        var sut = RequestConfiguration()

        #expect(sut.info == [:])

        sut = sut.info(["key1": "value1"])
        #expect(sut == .init(info: ["key1": "value1"]))

        sut = sut.info([
            "key2": "value2",
            "key3": "value3",
        ])
        #expect(
            sut == .init(info: [
                "key1": "value1",
                "key2": "value2",
                "key3": "value3",
            ])
        )

        sut = sut.info(["": ""])
        #expect(
            sut == .init(info: [
                "key1": "value1",
                "key2": "value2",
                "key3": "value3",
                "": "",
            ])
        )

        sut = sut.info([:])
        #expect(
            sut == .init(info: [
                "key1": "value1",
                "key2": "value2",
                "key3": "value3",
                "": "",
            ])
        )
    }

    @Test
    func info_single () {
        var sut = RequestConfiguration()

        #expect(sut.info == [:])

        sut = sut.info(key: "key1", value: "value1")
        #expect(sut == .init(info: ["key1": "value1"]))

        sut = sut.info(key: "key2", value: "value2")
        #expect(
            sut == .init(info: [
                "key1": "value1",
                "key2": "value2",
            ])
        )

        sut = sut.info(key: "", value: "")
        #expect(
            sut == .init(info: [
                "key1": "value1",
                "key2": "value2",
                "": "",
            ])
        )
    }

    @Test
    func timeout () {
        var sut = RequestConfiguration()

        #expect(sut.timeout == nil)

        sut = sut.timeout(0)
        #expect(sut == .init(timeout: 0))

        sut = sut.timeout(1)
        #expect(sut == .init(timeout: 1))

        sut = sut.timeout(10.5)
        #expect(sut == .init(timeout: 10.5))

        sut = sut.timeout(nil)
        #expect(sut == .init(address: nil))
    }

    @Test
    func host () {
        var sut = RequestConfiguration()

        #expect(sut.urlComponents.host == nil)

        sut = sut.host("com")
        #expect(sut.urlComponents.host == "com")

        sut = sut.host("domain")
        #expect(sut.urlComponents.host == "domain.com")

        sut = sut.host("sub")
        #expect(sut.urlComponents.host == "sub.domain.com")
    }

    @Test
    func path () {
        var sut = RequestConfiguration()

        #expect(sut.urlComponents.path == "")

        sut = sut.path("api")
        #expect(sut.urlComponents.path == "/api")

        sut = sut.path("user")
        #expect(sut.urlComponents.path == "/api/user")

        sut = sut.path("info")
        #expect(sut.urlComponents.path == "/api/user/info")
    }
}
