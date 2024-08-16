import XCTest

@testable import NetworkUtil

final class MockNetworkController_Tests: XCTestCase {
	func test_sendGetRequest_shouldReturnExpectedStubResponse () async throws {
		// MARK: Arrange
		let expectedResponseModel = "test"
		let expectedResultRequest = StandardRequest.get()
		let expectedUrlRequest = URLRequest(url: URLComponents().url!)

		let sut = MockNetworkController(stubResponseModel: expectedResponseModel)

		// MARK: Act
		let response = try await sut.send(.get(), responseModel: String.self)

		// MARK: Assert
		XCTAssertEqual(response.model, expectedResponseModel)

		assert(resultRequest: sut.resultRequest!, expectedRequest: expectedResultRequest)
		assert(resultUrlRequest: sut.resultUrlRequest!, expectedUrlRequest: expectedUrlRequest)
	}
}
