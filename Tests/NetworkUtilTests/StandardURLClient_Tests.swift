import XCTest
@testable import NetworkUtil

final class StandardURLClient_Tests: XCTestCase {
	let baseRequest = StandardRequest()
	let baseConfiguration = RequestConfiguration()

	var sut: StandardURLClient!

	override func tearDown () {
		sut = nil
	}

	func test_urlRequestCreation () async throws {
		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "/subpath")!)

		let sending: AnySending = { sendingModel, _ in
			self.assert(resultUrlRequest: sendingModel.urlRequest, expectedUrlRequest: expectedUrlRequest)

			return (.init(), .init())
		}

		// MARK: Arrange
		sut = .init(
			configuration: baseConfiguration,
			delegate: .standard(sending: sending)
		)

		let request = baseRequest
			.updateConfiguration { $0.path("subpath") }

		// MARK: Act
		_ = try await sut.send(request, delegate: .standard(decoding: { _, _, _ in Data() }))
	}

	func test_urlSessionCreation () async throws {
		// MARK: Assert
		let expectedUrlSession = URLSession(configuration: .default)

		let sending: AnySending = { sendingModel, _ in
			XCTAssertEqual(sendingModel.urlSession, expectedUrlSession)
			
			return (.init(), .init())
		}

		// MARK: Arrange
		sut = .init(
			configuration: baseConfiguration,
			delegate: .standard(
				urlSessionBuilder: expectedUrlSession,
				sending: sending
			)
		)

		let request = baseRequest

		// MARK: Act
		_ = try await sut.send(request, delegate: .standard(decoding: { _, _, _ in Data() }))
	}
}
