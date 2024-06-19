import XCTest
@testable import NetworkUtil

final class StandardNetworkController_Tests: XCTestCase {
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

	func test_urlRequestCreation () async throws {
		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "site.com/subpath")!)

		let sendingDelegate: SendingDelegate = { _, resultUrlRequest, _, _, _ in
			self.assert(resultUrlRequest: resultUrlRequest, expectedUrlRequest: expectedUrlRequest)

			return (.init(), .init())
		}

		// MARK: Arrange
		sut = StandardNetworkController(
			configuration: baseConfiguration,
			sendingDelegate: sendingDelegate
		)

		let request = baseRequest
			.set(path: "subpath")

		// MARK: Act
		_ = try await sut.send(request, decoding: { _ in Data() })
	}
}
