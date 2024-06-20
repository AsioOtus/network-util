import XCTest
@testable import NetworkUtil

final class StandardNetworkController_ResponseTests: XCTestCase {
	let baseRequest = StandardRequest(path: "")
	let baseConfiguration = URLRequestConfiguration(
		scheme: nil,
		address: "site.com",
		port: nil,
		baseSubpath: nil,
		query: [:],
		headers: [:],
		timeout: nil
	)

	var sut: StandardNetworkController!

	override func tearDown () {
		sut = nil
	}

	func test_expectedResponseData () async throws {
		// MARK: Arrange
		let expectedObject = "test"
		let expectedData = try JSONEncoder().encode(expectedObject)

		let sendingDelegate: SendingDelegateTypeErased = { _, _, _, _, _ in
			(expectedData, .init())
		}

		sut = .init(
			configuration: baseConfiguration,
			sendingDelegate: sendingDelegate
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

		let sendingDelegate: SendingDelegateTypeErased = { _, _, _, _, _ in
			(expectedData, .init())
		}

		sut = .init(
			configuration: baseConfiguration,
			sendingDelegate: sendingDelegate
		)

		// MARK: Act
		let standardResponse = try await sut.send(baseRequest, responseModel: String.self)

		// MARK: Assert
		XCTAssertEqual(standardResponse.model, expectedObject)
	}
}
