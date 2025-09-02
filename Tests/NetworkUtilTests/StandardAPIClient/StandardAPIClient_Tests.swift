import Foundation
import Testing

@testable import NetworkUtil

@Suite("StandardAPIClient")
struct StandardAPIClient_Tests {
    @Test
	func urlRequestCreation () async throws {
		// MARK: Assert
		let expectedUrlRequest = URLRequest(url: .init(string: "/subpath")!)

		let sending: AnySending = { sendingModel, _ in
            #expect(sendingModel.urlRequest == expectedUrlRequest)

			return (.init(), .init())
		}

		// MARK: Arrange
        let sut = StandardAPIClient(
			configuration: RequestConfiguration(),
			delegate: .standard(sending: sending)
		)

		let request = StandardRequest().updateConfiguration { $0.path("subpath") }

		// MARK: Act
		_ = try await sut.send(request, delegate: .standard(decoding: { _, _, _ in Data() }))
	}

    @Test
	func urlSessionCreation () async throws {
		// MARK: Assert
		let expectedUrlSession = URLSession(configuration: .default)

		let sending: AnySending = { sendingModel, _ in
            #expect(sendingModel.urlSession == expectedUrlSession)

			return (.init(), .init())
		}

		// MARK: Arrange
		let sut = StandardAPIClient(
			configuration: RequestConfiguration(),
			delegate: .standard(
				urlSessionBuilder: expectedUrlSession,
				sending: sending
			)
		)

		let request = StandardRequest()

		// MARK: Act
		_ = try await sut.send(request, delegate: .standard(decoding: { _, _, _ in Data() }))
	}
}
