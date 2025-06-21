import XCTest
@testable import NetworkUtil

final class StandardAPIClient_ResponseTests: XCTestCase {
	let baseRequest = StandardRequest()
	let baseConfiguration = RequestConfiguration()

	var sut: StandardAPIClient!

	override func tearDown () {
		sut = nil
	}

	func test_expectedResponseData () async throws {
		// MARK: Arrange
		let expectedObject = "test"
		let expectedData = try JSONEncoder().encode(expectedObject)

		let sending: AnySending = { _, _ in (expectedData, .init()) }

		sut = .init(
			configuration: baseConfiguration,
			delegate: .standard(sending: sending)
		)

		// MARK: Act
		let standardResponse = try await sut.send(baseRequest)

		// MARK: Assert
		XCTAssertEqual(standardResponse.data, expectedData)
	}

	func test_expectedResponseModel () async throws {
		// MARK: Arrange
		let expectedObject = "test"
		let expectedData = try JSONEncoder().encode(expectedObject)

		let sending: AnySending = { _, _ in
			(expectedData, .init())
		}

		sut = .init(
			configuration: baseConfiguration,
			delegate: .standard(sending: sending)
		)

		// MARK: Act
		let standardResponse = try await sut.send(baseRequest, responseModel: String.self)

		// MARK: Assert
		XCTAssertEqual(standardResponse.model, expectedObject)
	}

	func test_plainDataResponse () async throws {
		// MARK: Arrange
		let expectedData = "test".data(using: .utf8)!

		let sending: AnySending = { _, _ in
			(expectedData, .init())
		}

		sut = .init(
			configuration: baseConfiguration,
			delegate: .standard(sending: sending)
		)

		// MARK: Act
		let standardResponse = try await sut.send(baseRequest)

		// MARK: Assert
		XCTAssertEqual(standardResponse.model, expectedData)
	}
}
