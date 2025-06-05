import Testing

@testable import NetworkUtil

struct RequestConfiguration_ConfigurationTests {
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
