import Foundation
import Testing

@testable import NetworkUtil

struct URLComponents_MergeTest {
    @Test
    func test_full () {
        // Arrange
        let sut1 = URLComponents(
            scheme: "scheme1",
            user: "user1",
            password: "password1",
            host: "host1",
            port: 1,
            path: "path1",
            queryItems: [.init(name: "key1", value: "value1")],
            fragment: "fragment1"
        )
        let sut2 = URLComponents(
            scheme: "scheme2",
            user: "user2",
            password: "password2",
            host: "host2",
            port: 2,
            path: "path2",
            queryItems: [.init(name: "key2", value: "value2")],
            fragment: "fragment2"
        )

        // Act
        let resultWith = sut1.merge(with: sut2)

        // Assert
        let expectedWith = URLComponents(
            scheme: "scheme1",
            user: "user1",
            password: "password1",
            host: "host1.host2",
            port: 1,
            path: "/path2/path1",
            queryItems: [
                .init(name: "key2", value: "value2"),
                .init(name: "key1", value: "value1"),
            ],
            fragment: "fragment1"
        )
        #expect(resultWith == expectedWith)

        // Act
        let resultInto = sut1.merge(into: sut2)

        // Assert
        let expectedInto = URLComponents(
            scheme: "scheme2",
            user: "user2",
            password: "password2",
            host: "host2.host1",
            port: 2,
            path: "/path1/path2",
            queryItems: [
                .init(name: "key1", value: "value1"),
                .init(name: "key2", value: "value2"),
            ],
            fragment: "fragment2"
        )
        #expect(resultInto == expectedInto)
    }

    @Test
    func test_empty () {
        // Arrange
        let sut1 = URLComponents()
        let sut2 = URLComponents(
            scheme: "scheme2",
            user: "user2",
            password: "password2",
            host: "host2",
            port: 2,
            path: "path2",
            queryItems: [.init(name: "key2", value: "value2")],
            fragment: "fragment2"
        )

        // Act
        let resultWith = sut1.merge(with: sut2)

        // Assert
        let expectedWith = URLComponents(
            scheme: "scheme2",
            user: "user2",
            password: "password2",
            host: "host2",
            port: 2,
            path: "/path2",
            queryItems: [
                .init(name: "key2", value: "value2"),
            ],
            fragment: "fragment2"
        )
        #expect(resultWith == expectedWith)

        // Act
        let resultInto = sut1.merge(with: sut2)

        // Assert
        let expectedInto = URLComponents(
            scheme: "scheme2",
            user: "user2",
            password: "password2",
            host: "host2",
            port: 2,
            path: "/path2",
            queryItems: [
                .init(name: "key2", value: "value2"),
            ],
            fragment: "fragment2"
        )
        #expect(resultInto == expectedInto)
    }
}
