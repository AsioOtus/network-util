import Foundation
import Testing

@testable import NetworkUtil

struct URLComponents_PropertiesTest {
    @Test
    func prefixedPath () {
        let sut = URLComponents().path("path", raw: true)

        #expect(sut.path == "path")
        #expect(sut.prefixedPath == "/path")
    }

    @Test
    func queryItemsOrEmpty () {
        var sut = URLComponents()

        #expect(sut.queryItems == nil)
        #expect(sut.queryItemsOrEmpty == [])

        sut = sut.queryItem(.init(name: "key", value: "value"))
        #expect(sut.queryItemsOrEmpty == [.init(name: "key", value: "value")])

        sut = sut.setQueryItems(nil)
        #expect(sut.queryItemsOrEmpty == [])
    }
}
