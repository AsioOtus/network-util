import XCTest
@testable import NetworkUtil

final class StandardURLRequestBuilder_ConfigurationTests: XCTestCase {
	let baseRequest = StandardRequest(path: "")
	let baseConfiguration = URLRequestConfiguration(
		scheme: nil,
		address: "",
		port: nil,
		baseSubpath: nil,
		query: [:],
		headers: [:],
		timeout: nil
	)

	var sut: StandardURLRequestBuilder!

	override func setUp () {
		sut = .init()
	}

	func test_address () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")

		let request = baseRequest

		// MARK: Act
		let resultUrlRequest = try sut.build(request, nil, configuration)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "site.com/")!)

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_address_basesubpath () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")
			.setBaseSubpath("base-subpath")

		let request = baseRequest

		// MARK: Act
		let resultUrlRequest = try sut.build(request, nil, configuration)

		// MARK: Assert
		var expectedUrlRequest = URLRequest(url: .init(string: "site.com/base-subpath/")!)
		expectedUrlRequest.timeoutInterval = 10

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_address_port () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")
			.setPort(1111)

		let request = baseRequest

		// MARK: Act
		let resultUrlRequest = try sut.build(request, nil, configuration)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "site.com:1111")!)

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.url?.port, expectedUrlRequest.url?.port)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_address_scheme () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")
			.setScheme("http")

		let request = baseRequest

		// MARK: Act
		let resultUrlRequest = try sut.build(request, nil, configuration)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "http://site.com/")!)

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.url?.scheme, expectedUrlRequest.url?.scheme)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_address_timeout () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")
			.setTimeout(10)

		let request = baseRequest

		// MARK: Act
		let resultUrlRequest = try sut.build(request, nil, configuration)

		// MARK: Assert
		var expectedUrlRequest = URLRequest(url: .init(string: "site.com/")!)
		expectedUrlRequest.timeoutInterval = 10

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.timeoutInterval, expectedUrlRequest.timeoutInterval)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_empty () throws {
		// MARK: Arrange
		let configuration = URLRequestConfiguration.empty
		let request = baseRequest

		// MARK: Act
		XCTAssertThrowsError(try sut.build(request, nil, configuration)) { error in
			// MARK: Assert
			guard case GeneralError.urlComponentsCreationFailure = error else {
				XCTFail()
				return
			}
		}
	}
}
