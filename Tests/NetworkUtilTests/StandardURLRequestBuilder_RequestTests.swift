import XCTest
@testable import NetworkUtil

final class StandardURLRequestBuilder_RequestTests: XCTestCase {
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

	func test_address_subpath () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")

		let request = baseRequest
			.set(path: "subpath")

		// MARK: Act
		let resultUrlRequest = try sut.build(request, nil, configuration)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "site.com/subpath")!)
		
		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_address_method () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")

		let request = baseRequest
			.set(method: .post)

		// MARK: Act
		let resultUrlRequest = try sut.build(request, nil, configuration)

		// MARK: Assert
		var expectedUrlRequest = URLRequest(url: .init(string: "site.com/")!)
		expectedUrlRequest.httpMethod = "POST"

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.httpMethod, expectedUrlRequest.httpMethod)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_address_body () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")

		let request = baseRequest

		let data = "body".data(using: .utf8)!

		// MARK: Act
		let resultUrlRequest = try sut.build(request, data, configuration)

		// MARK: Assert
		var expectedUrlRequest = URLRequest(url: .init(string: "site.com/")!)
		expectedUrlRequest.httpBody = data

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.httpBody, expectedUrlRequest.httpBody)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func test_address_body_request () throws {
		// MARK: Arrange
		let configuration = baseConfiguration
			.setAddress("site.com")

		let data = "body".data(using: .utf8)!

		let request = baseRequest
			.set(body: data)

		// MARK: Act
		let resultUrlRequest = try sut.build(request, request.body, configuration)

		// MARK: Assert
		var expectedUrlRequest = URLRequest(url: .init(string: "site.com/")!)
		expectedUrlRequest.httpBody = data

		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.httpBody, expectedUrlRequest.httpBody)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}
}
