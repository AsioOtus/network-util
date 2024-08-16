import XCTest

@testable import NetworkUtil

final class StandardNetworkController_SendingTests: XCTestCase {
	func test_sendingMerging () async throws {
		// MARK: Arrange
		let expectedObject = "test"
		let expectedData = try JSONEncoder().encode(expectedObject)

		var expectedUrlRequest = URLRequest(url: URLComponents().url!)
		expectedUrlRequest.httpBody = expectedData
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

		let sut = StandardNetworkController(
			delegate: .standard(sending: anySending)
		)

		// MARK: Act
		let standardResponse = try await sut.send(
			.get(),
			delegate: .standard(sending: sending)
		)

		// MARK: Assert
		XCTAssertEqual(standardResponse.data, expectedData)
		XCTAssertEqual(resultUrlRequests, [expectedUrlRequest, overridingExpectedUrlRequest])
		XCTAssertEqual(sendingCalls, ["AnySending", "Sending"])
	}
}
