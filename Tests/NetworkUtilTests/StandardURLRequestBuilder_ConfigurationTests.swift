import Foundation
import Testing

@testable import NetworkUtil

struct StandardURLRequestBuilder_ConfigurationTests {
    @Test 
	func host () throws {
		// MARK: Arrange
        let sut = StandardURLRequestBuilder()

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
            configuration: .empty.host("site.com"),
			body: nil
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "//site.com")!)

        #expect(resultUrlRequest == expectedUrlRequest)
	}

    @Test 
	func host_subpath () throws {
		// MARK: Arrange
        let sut = StandardURLRequestBuilder()


		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
            configuration: .empty
                .path("base-subpath")
                .path("/added-subpath"),
			body: nil
		)

		// MARK: Assert
        let expectedUrlRequest = URLRequest(url: .init(string: "/base-subpath/added-subpath")!)
        #expect(resultUrlRequest == expectedUrlRequest)
	}

    @Test
    func host_rawSubpath () throws {
        // MARK: Arrange
        let sut = StandardURLRequestBuilder()

        // MARK: Act
        let resultUrlRequest = try sut.build(
            address: nil,
            configuration: .empty.path("/base-subpath", raw: true),
            body: nil
        )

        // MARK: Assert
        let expectedUrlRequest = URLRequest(url: .init(string: "/base-subpath")!)
        #expect(resultUrlRequest == expectedUrlRequest)
    }

    @Test
    func host_subpathAdding () throws {
        // MARK: Arrange
        let sut = StandardURLRequestBuilder()

        // MARK: Act
        let resultUrlRequest = try sut.build(
            address: nil,
            configuration: .empty
                .path("base-subpath")
                .path("added-subpath"),
            body: nil
        )

        // MARK: Assert
        let expectedUrlRequest = URLRequest(url: .init(string: "/base-subpath/added-subpath")!)
        #expect(resultUrlRequest == expectedUrlRequest)
    }

    @Test
    func host_rawSubpathAdding () throws {
        // MARK: Arrange
        let sut = StandardURLRequestBuilder()

        // MARK: Act
        let resultUrlRequest = try sut.build(
            address: nil,
            configuration: .empty
                .path("/base-subpath", raw: true)
                .path("/added-subpath", raw: true),
            body: nil
        )

        // MARK: Assert
        let expectedUrlRequest = URLRequest(url: .init(string: "/base-subpath/added-subpath")!)
        #expect(resultUrlRequest == expectedUrlRequest)
    }

    @Test
	func host_port () throws {
		// MARK: Arrange
        let sut = StandardURLRequestBuilder()

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
			configuration: .empty.port(1111),
			body: nil
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "//:1111")!)
        #expect(resultUrlRequest == expectedUrlRequest)
	}

    @Test
	func host_scheme () throws {
		// MARK: Arrange
        let sut = StandardURLRequestBuilder()

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
			configuration: .empty.scheme("http"),
			body: nil
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "http:")!)
        #expect(resultUrlRequest == expectedUrlRequest)
	}

    @Test
	func host_timeout () throws {
		// MARK: Arrange
        let sut = StandardURLRequestBuilder()

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
			configuration: .empty.host("site.com").timeout(10),
			body: nil
		)

		// MARK: Assert
		var expectedUrlRequest = URLRequest(url: .init(string: "//site.com")!)
		expectedUrlRequest.timeoutInterval = 10
        #expect(resultUrlRequest == expectedUrlRequest)
	}
}
