import Foundation
import Testing

@testable import NetworkUtil

@Suite("StandardAPIClient – sending")
struct StandardAPIClient_SendingTests {
    @Test
	func sendingMerging () async throws {
		// MARK: Arrange
		let expectedObject = "test"
		let expectedData = try JSONEncoder().encode(expectedObject)

		let overridingExpectedUrlRequest = URLRequest(url: .init(string: "expected.com")!)
		var resultUrlRequests = [URLRequest]()
		var sendingCalls = [String]()

		let anySending: AnySending = {
			sendingCalls.append("AnySending")
			resultUrlRequests.append($0.urlRequest)
			return try await $1($0.urlSession, overridingExpectedUrlRequest)
		}

		let sending: Sending<StandardRequest<Data>> = { sendingModel, _ in
			sendingCalls.append("Sending")
			resultUrlRequests.append(sendingModel.urlRequest)
			return (expectedData, .init())
		}

		let sut = StandardAPIClient(
			delegate: .standard(sending: anySending)
		)

		// MARK: Act
		let standardResponse = try await sut.send(
			.get(),
			delegate: .standard(sending: sending)
		)

		// MARK: Assert
        var expectedUrlRequest = URLRequest(url: URLComponents().url!)
        expectedUrlRequest.httpBody = expectedData

        #expect(standardResponse.data == expectedData)
        #expect(resultUrlRequests == [expectedUrlRequest, overridingExpectedUrlRequest])
        #expect(sendingCalls == ["AnySending", "Sending"])
	}
}
