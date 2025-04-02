import XCTest

@testable import NetworkUtil

final class MockURLClient_Tests: XCTestCase {
	func test_sendGetRequest_shouldReturnExpectedStubResponse () async throws {
		// MARK: Arrange
		let expectedResponseModel = "test"
		let expectedUrlRequest = URLRequest(url: URLComponents().url!)

		let sut = MockURLClient(stubResponseModel: expectedResponseModel)

		// MARK: Act
		let response = try await sut.send(.get(), responseModel: String.self)

		// MARK: Assert
		XCTAssertEqual(response.model, expectedResponseModel)

		assert(resultUrlRequest: sut.resultUrlRequest!, expectedUrlRequest: expectedUrlRequest)
	}
}
