import XCTest
@testable import NetworkUtil

final class StandardNetworkController_InitTests: XCTestCase {
	func test_minimalInit () {
		// MARK: Act
		_ = StandardNetworkController()

		// MARK: Assert
		XCTAssert(true)
	}

	func test_minimalSend () async throws {
		// MARK: Arrange
		let sut = StandardNetworkController()

		// MARK: Act
		_ = try await sut.send(.get("site.com"), delegate: .standard(sending: mockSending()))

		// MARK: Assert
		XCTAssert(true)
	}
}
