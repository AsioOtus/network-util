import XCTest
@testable import NetworkUtil

final class StandardNetworkController_Tests: XCTestCase {
	let baseRequest = StandardRequest()
	let baseConfiguration = RequestConfiguration()

	var sut: StandardNetworkController!

	override func tearDown () {
		sut = nil
	}

	func test_urlRequestCreation () async throws {
		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "/subpath")!)

		let sending: SendingTypeErased = { _, resultUrlRequest, _, _, _ in
			self.assert(resultUrlRequest: resultUrlRequest, expectedUrlRequest: expectedUrlRequest)

			return (.init(), .init())
		}

		// MARK: Arrange
		sut = .init(
			configuration: baseConfiguration,
			delegate: .delegate(sending: sending)
		)

		let request = baseRequest
			.configuration { $0.setPath("subpath") }

		// MARK: Act
		_ = try await sut.send(request, delegate: .standard(decoding: { _ in Data() }))
	}

	func test_urlSessionCreation () async throws {
		// MARK: Assert
		let expectedUrlSession = URLSession(configuration: .default)

		let sending: SendingTypeErased = { resultUrlSession, _, _, _, _ in
			XCTAssertEqual(resultUrlSession, expectedUrlSession)
			
			return (.init(), .init())
		}

		// MARK: Arrange
		sut = .init(
			configuration: baseConfiguration,
			delegate: .delegate(
				urlSessionBuilder: expectedUrlSession,
				sending: sending
			)
		)

		let request = baseRequest

		// MARK: Act
		_ = try await sut.send(request, delegate: .standard(decoding: { _ in Data() }))
	}
}
