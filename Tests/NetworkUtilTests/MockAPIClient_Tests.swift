import Foundation
import Testing

@testable import NetworkUtil

@Suite("MockAPIClient")
struct MockAPIClientTests {
    @Test("send method should return stub response")
	func sendMethodShouldReturnStubResponse () async throws {
		// MARK: Arrange
		let expectedResponseModel = "test"
		let expectedUrlRequest = URLRequest(url: URLComponents().url!)

		let sut = MockAPIClient(stubResponseModel: expectedResponseModel)

		// MARK: Act
		let response = try await sut.send(.get(), responseModel: String.self)

		// MARK: Assert
        #expect(response.model == expectedResponseModel)
        #expect(sut.resultUrlRequest == expectedUrlRequest)
	}
}
