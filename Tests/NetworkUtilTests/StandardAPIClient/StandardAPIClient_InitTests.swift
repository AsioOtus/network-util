import Testing

@testable import NetworkUtil

struct StandardAPIClient_InitTests {
    @Test
	func minimalInit () {
		_ = StandardAPIClient()
	}

    @Test
	func minimalSend () async throws {
		let sut = StandardAPIClient()

		_ = try await sut.send(.get("site.com"), delegate: .standard(sending: mockSending()))
	}
}
