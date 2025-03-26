import XCTest
@testable import NetworkUtil

final class StandardURLRequestBuilder_ConfigurationTests: XCTestCase {
	let baseConfiguration = RequestConfiguration(urlComponents: .init(host: "site.com"))

	var sut: StandardURLRequestBuilder!

	override func setUp () {
		sut = .init()
	}

	func test_host () throws {
		// MARK: Arrange
		let configuration = baseConfiguration

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
			configuration: configuration,
			body: nil
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "//site.com")!)

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_host_subpath () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.path("base-subpath")

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
			configuration: configuration,
			body: nil
		)

		// MARK: Assert
		var expectedUrlRequest = URLRequest(url: .init(string: "//site.com/base-subpath")!)
		expectedUrlRequest.timeoutInterval = 10

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

    func test_host_pureSubpath () throws {
        // MARK: Arrange
        let configuration = baseConfiguration
            .purePath("/base-subpath")

        // MARK: Act
        let resultUrlRequest = try sut.build(
            address: nil,
            configuration: configuration,
            body: nil
        )

        // MARK: Assert
        var expectedUrlRequest = URLRequest(url: .init(string: "//site.com/base-subpath")!)
        expectedUrlRequest.timeoutInterval = 10

        XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
        XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
    }

    func test_host_subpathAdding () throws {
        // MARK: Arrange
        let configuration = baseConfiguration
            .path("base-subpath")
            .addPath("added-subpath")

        // MARK: Act
        let resultUrlRequest = try sut.build(
            address: nil,
            configuration: configuration,
            body: nil
        )

        // MARK: Assert
        var expectedUrlRequest = URLRequest(url: .init(string: "//site.com/base-subpath/added-subpath")!)
        expectedUrlRequest.timeoutInterval = 10

        XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
        XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
    }

    func test_host_pureSubpathAdding () throws {
        // MARK: Arrange
        let configuration = baseConfiguration
            .purePath("/base-subpath")
            .addPurePath("/added-subpath")

        // MARK: Act
        let resultUrlRequest = try sut.build(
            address: nil,
            configuration: configuration,
            body: nil
        )

        // MARK: Assert
        var expectedUrlRequest = URLRequest(url: .init(string: "//site.com/base-subpath/added-subpath")!)
        expectedUrlRequest.timeoutInterval = 10

        XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
        XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
    }

	func test_host_port () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.port(1111)

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
			configuration: configuration,
			body: nil
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "//site.com:1111")!)

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.url?.port, expectedUrlRequest.url?.port)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_host_scheme () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.scheme("http")

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
			configuration: configuration,
			body: nil
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "http://site.com")!)

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.url?.scheme, expectedUrlRequest.url?.scheme)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_host_timeout () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.timeout(10)

		// MARK: Act
		let resultUrlRequest = try sut.build(
			address: nil,
			configuration: configuration,
			body: nil
		)

		// MARK: Assert
		var expectedUrlRequest = URLRequest(url: .init(string: "//site.com")!)
		expectedUrlRequest.timeoutInterval = 10

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.timeoutInterval, expectedUrlRequest.timeoutInterval)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}
}
