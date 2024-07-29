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
			.set(path: "subpath")

		// MARK: Act
		_ = try await sut.send(request, .delegate(decoding: { _ in Data() }))
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
		_ = try await sut.send(request, .delegate(decoding: { _ in Data() }))
	}
}
