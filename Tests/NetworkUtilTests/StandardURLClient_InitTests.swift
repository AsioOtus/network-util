import XCTest
@testable import NetworkUtil

final class StandardURLClient_InitTests: XCTestCase {
	func test_minimalInit () {
		// MARK: Act
		_ = StandardURLClient()

		// MARK: Assert
		XCTAssert(true)
	}

	func test_minimalSend () async throws {
		// MARK: Arrange
		let sut = StandardURLClient()

		// MARK: Act
		_ = try await sut.send(.get("site.com"), delegate: .standard(sending: mockSending()))

		// MARK: Assert
		XCTAssert(true)
	}
}
