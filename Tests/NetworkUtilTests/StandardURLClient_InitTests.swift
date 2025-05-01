import XCTest
@testable import NetworkUtil

final class StandardAPIClient_InitTests: XCTestCase {
	func test_minimalInit () {
		// MARK: Act
		_ = StandardAPIClient()

		// MARK: Assert
		XCTAssert(true)
	}

	func test_minimalSend () async throws {
		// MARK: Arrange
		let sut = StandardAPIClient()

		// MARK: Act
		_ = try await sut.send(.get("site.com"), delegate: .standard(sending: mockSending()))

		// MARK: Assert
		XCTAssert(true)
	}
}
