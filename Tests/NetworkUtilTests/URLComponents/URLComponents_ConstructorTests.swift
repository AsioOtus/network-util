import Foundation
import Testing

@testable import NetworkUtil

struct URLComponents_ConstructorTests {
    @Test
    func http () {
        let sut = URLComponents.http()

        #expect(sut.scheme == "http")
    }

    @Test
    func https () {
        let sut = URLComponents.https()

        #expect(sut.scheme == "https")
    }
}
