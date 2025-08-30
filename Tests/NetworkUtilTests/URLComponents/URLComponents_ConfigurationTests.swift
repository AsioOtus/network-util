import Foundation
import Testing

@testable import NetworkUtil

struct URLComponents_ConfigurationTests {
    @Test
    func scheme () {
        var sut = URLComponents()

        #expect(sut.scheme == nil)

        sut = sut.scheme("http")
        #expect(sut.scheme == "http")

        sut = sut.scheme("https")
        #expect(sut.scheme == "https")

        sut = sut.scheme(nil)
        #expect(sut.scheme == nil)

        sut = sut.scheme("file")
        #expect(sut.scheme == "file")
    }

    @Test
    func user () {
        var sut = URLComponents()

        #expect(sut.user == nil)

        sut = sut.user("username1")
        #expect(sut.user == "username1")

        sut = sut.user("username2")
        #expect(sut.user == "username2")

        sut = sut.user(nil)
        #expect(sut.user == nil)

        sut = sut.user("username3")
        #expect(sut.user == "username3")
    }

    @Test
    func password () {
        var sut = URLComponents()

        #expect(sut.password == nil)

        sut = sut.password("password1")
        #expect(sut.password == "password1")

        sut = sut.password("password2")
        #expect(sut.password == "password2")

        sut = sut.password(nil)
        #expect(sut.password == nil)

        sut = sut.password("password3")
        #expect(sut.password == "password3")
    }

    @Test
    func setHost () {
        var sut = URLComponents()

        #expect(sut.host == nil)

        sut = sut.setHost("domain1.com")
        #expect(sut.host == "domain1.com")

        sut = sut.setHost("domain2.org")
        #expect(sut.host == "domain2.org")

        sut = sut.setHost(nil)
        #expect(sut.host == nil)

        sut = sut.setHost("domain3.net")
        #expect(sut.host == "domain3.net")
    }

    @Test
    func host () {
        var sut = URLComponents()

        #expect(sut.host == nil)

        sut = sut.host("com")
        #expect(sut.host == "com")

        sut = sut.host("domain")
        #expect(sut.host == "domain.com")

        sut = sut.host("sub")
        #expect(sut.host == "sub.domain.com")

        sut = sut.host("www.")
        #expect(sut.host == "www.sub.domain.com")

        sut = sut.host("mail..")
        #expect(sut.host == "mail..www.sub.domain.com")

        sut = sut.host("test...")
        #expect(sut.host == "test...mail..www.sub.domain.com")

        sut = sut.host(".abc.")
        #expect(sut.host == ".abc.test...mail..www.sub.domain.com")
    }

    @Test
    func host_onlyDots () {
        var sut = URLComponents()

        sut = sut.host(".")
        #expect(sut.host == ".")

        sut = sut.host("..")
        #expect(sut.host == ".")

        sut = sut.host("...")
        #expect(sut.host == "..")
    }

    @Test
    func rawHost_withoutDots () {
        var sut = URLComponents()

        #expect(sut.host == nil)

        sut = sut.host("com", raw: true)
        #expect(sut.host == "com")

        sut = sut.host("domain", raw: true)
        #expect(sut.host == "domaincom")

        sut = sut.host("sub", raw: true)
        #expect(sut.host == "subdomaincom")
    }

    @Test
    func rawHost_withDots () {
        var sut = URLComponents()

        sut = sut.host(".com", raw: true)
        #expect(sut.host == ".com")

        sut = sut.host(".domain", raw: true)
        #expect(sut.host == ".domain.com")

        sut = sut.host("sub", raw: true)
        #expect(sut.host == "sub.domain.com")

        sut = sut.host(".www..", raw: true)
        #expect(sut.host == ".www..sub.domain.com")

        sut = sut.host("mail.", raw: true)
        #expect(sut.host == "mail..www..sub.domain.com")
    }

    @Test
    func rawHost_onlyDots () {
        var sut = URLComponents()

        sut = sut.host(".", raw: true)
        #expect(sut.host == ".")

        sut = sut.host("..", raw: true)
        #expect(sut.host == "...")
    }

    @Test
    func port () {
        var sut = URLComponents()

        #expect(sut.port == nil)

        sut = sut.port(1)
        #expect(sut.port == 1)

        sut = sut.port(2)
        #expect(sut.port == 2)

        sut = sut.port(nil)
        #expect(sut.port == nil)

        sut = sut.port(8888)
        #expect(sut.port == 8888)
    }

    @Test
    func setPath () {
        var sut = URLComponents()

        #expect(sut.path == "")

        sut = sut.setPath("abc")
        #expect(sut.path == "/abc")

        sut = sut.setPath("def")
        #expect(sut.path == "/def")

        sut = sut.setPath("ghi")
        #expect(sut.path == "/ghi")

        sut = sut.setPath("/abc")
        #expect(sut.path == "/abc")

        sut = sut.setPath("def//")
        #expect(sut.path == "/def//")

        sut = sut.setPath("/ghi/")
        #expect(sut.path == "/ghi/")

        sut = sut.setPath("/")
        #expect(sut.path == "/")

        sut = sut.setPath("//")
        #expect(sut.path == "//")

        sut = sut.setPath("///")
        #expect(sut.path == "///")
    }

    @Test
    func path () {
        var sut = URLComponents()

        #expect(sut.path == "")

        sut = sut.path("api")
        #expect(sut.path == "/api")

        sut = sut.path("user")
        #expect(sut.path == "/api/user")

        sut = sut.path("info")
        #expect(sut.path == "/api/user/info")

        sut = sut.setPath("")
        #expect(sut.path == "")

        sut = sut.path("api/")
        #expect(sut.path == "/api/")

        sut = sut.path("/user")
        #expect(sut.path == "/api/user")

        sut = sut.path("//info")
        #expect(sut.path == "/api/user//info")
    }

    @Test 
    func setRawPath () {
        var sut = URLComponents()

        #expect(sut.path == "")

        sut = sut.setPath("abc", raw: true)
        #expect(sut.path == "abc")

        sut = sut.setPath("def", raw: true)
        #expect(sut.path == "def")

        sut = sut.setPath("ghi", raw: true)
        #expect(sut.path == "ghi")

        sut = sut.setPath("/abc", raw: true)
        #expect(sut.path == "/abc")

        sut = sut.setPath("def//", raw: true)
        #expect(sut.path == "def//")

        sut = sut.setPath("/ghi/", raw: true)
        #expect(sut.path == "/ghi/")
    }

    @Test
    func rawPath () {
        var sut = URLComponents()

        #expect(sut.path == "")

        sut = sut.path("api", raw: true)
        #expect(sut.path == "api")

        sut = sut.path("user", raw: true)
        #expect(sut.path == "apiuser")

        sut = sut.path("info", raw: true)
        #expect(sut.path == "apiuserinfo")

        sut = sut.setPath("")
        #expect(sut.path == "")

        sut = sut.path("api/", raw: true)
        #expect(sut.path == "api/")

        sut = sut.path("user/", raw: true)
        #expect(sut.path == "api/user/")

        sut = sut.path("info/", raw: true)
        #expect(sut.path == "api/user/info/")

        sut = sut.path("/details", raw: true)
        #expect(sut.path == "api/user/info//details")
    }

    @Test
    func setQueryItems () {
        var sut = URLComponents()

        #expect(sut.queryItems == nil)

        sut = sut.setQueryItems([
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
        ])
        #expect(sut.queryItems == [
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
        ])

        sut = sut.setQueryItems([
            .init(name: "key3", value: "value3"),
            .init(name: "key4", value: "value4"),
        ])
        #expect(sut.queryItems == [
            .init(name: "key3", value: "value3"),
            .init(name: "key4", value: "value4"),
        ])

        sut = sut.setQueryItems(nil)
        #expect(sut.queryItems == nil)

        sut = sut.setQueryItems([
            .init(name: "key5", value: "value5"),
            .init(name: "key6", value: "value6"),
        ])
        #expect(sut.queryItems == [
            .init(name: "key5", value: "value5"),
            .init(name: "key6", value: "value6"),
        ])
    }

    @Test
    func setQueryItems_emptyAndNil () {
        var sut = URLComponents()

        #expect(sut.queryItems == nil)

        sut = sut.setQueryItems([])
        #expect(sut.queryItems == [])

        sut = sut.setQueryItems(nil)
        #expect(sut.queryItems == nil)
    }

    @Test
    func setQueryItem () {
        var sut = URLComponents()

        #expect(sut.queryItems == nil)

        sut = sut.setQueryItem(.init(name: "key1", value: "value1"))
        #expect(sut.queryItems == [.init(name: "key1", value: "value1")])

        sut = sut.setQueryItem(.init(name: "key2", value: "value2"))
        #expect(sut.queryItems == [.init(name: "key2", value: "value2")])
    }

    @Test
    func queryItems () {
        var sut = URLComponents()

        #expect(sut.queryItems == nil)

        sut = sut.queryItems([
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
        ])
        #expect(sut.queryItems == [
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
        ])

        sut = sut.queryItems([
            .init(name: "key3", value: "value3"),
            .init(name: "key4", value: "value4"),
        ])
        #expect(sut.queryItems == [
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
            .init(name: "key3", value: "value3"),
            .init(name: "key4", value: "value4"),
        ])
    }

    @Test
    func queryItems_duplicatedKeys () {
        var sut = URLComponents()

        #expect(sut.queryItems == nil)

        sut = sut.queryItems([
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
        ])
        #expect(sut.queryItems == [
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
        ])

        sut = sut.queryItems([
            .init(name: "key1", value: "value1"),
            .init(name: "key3", value: "value3"),
        ])
        #expect(sut.queryItems == [
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
            .init(name: "key1", value: "value1"),
            .init(name: "key3", value: "value3"),
        ])
    }

    @Test
    func queryItem () {
        var sut = URLComponents()

        #expect(sut.queryItems == nil)

        sut = sut.queryItem(.init(name: "key1", value: "value1"))
        #expect(sut.queryItems == [.init(name: "key1", value: "value1"),])

        sut = sut.queryItem(.init(name: "key2", value: "value2"))
        #expect(sut.queryItems == [
            .init(name: "key1", value: "value1"),
            .init(name: "key2", value: "value2"),
        ])
    }

    @Test
    func queryItem_duplicatedKeys () {
        var sut = URLComponents()

        #expect(sut.queryItems == nil)

        sut = sut.queryItem(.init(name: "key1", value: "value1"))
        #expect(sut.queryItems == [.init(name: "key1", value: "value1")])

        sut = sut.queryItem(.init(name: "key1", value: "value1"))
        #expect(sut.queryItems == [
            .init(name: "key1", value: "value1"),
            .init(name: "key1", value: "value1"),
        ])
    }

    @Test
    func fragment () {
        var sut = URLComponents()

        #expect(sut.fragment == nil)

        sut = sut.fragment("fragment1")
        #expect(sut.fragment == "fragment1")

        sut = sut.fragment("fragment2")
        #expect(sut.fragment == "fragment2")

        sut = sut.fragment(nil)
        #expect(sut.fragment == nil)

        sut = sut.fragment("fragment3")
        #expect(sut.fragment == "fragment3")

        sut = sut.fragment("")
        #expect(sut.fragment == "")
    }
}
