import XCTest
@testable import NetworkUtil

final class RequestConfiguration_MergingTests: XCTestCase {
	func test_mergingOfUrlClientAndRequestConfigurations_differentQueryMerging () async throws {
		// MARK: Arrange
		let request = StandardRequest(
			configuration: .init()
				.queryItems([
					.init(name: "request.key1", value: "request.value1"),
					.init(name: "request.key2", value: "request.value2"),
				])
		)

		let client = StandardAPIClient(
			configuration: .empty
				.queryItems([
					.init(name: "client.key1", value: "client.value1"),
					.init(name: "client.key2", value: "client.value2"),
				])
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(
			url: .init(
				string: "?client.key1=client.value1&client.key2=client.value2&request.key1=request.value1&request.key2=request.value2"
			)!
		)

		let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
			self.assert(resultUrlRequest: urlRequest, expectedUrlRequest: expectedUrlRequest)
		}

		// MARK: Act
		_ = try await client.send(
			request,
			delegate: .standard(sending: sending)
		)
	}

	func test_mergingOfUrlClientAndRequestConfigurations_equalQueryMerging () async throws {
		// MARK: Arrange
		let request = StandardRequest(
			configuration: .init()
				.queryItems([
					.init(name: "key1", value: "value1"),
					.init(name: "key2", value: "value2"),
				])
		)

		let client = StandardAPIClient(
			configuration: .empty
				.queryItems([
					.init(name: "key1", value: "value1"),
					.init(name: "key2", value: "value2"),
				])
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(
			url: .init(
				string: "?key1=value1&key2=value2&key1=value1&key2=value2"
			)!
		)

		let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
			self.assert(resultUrlRequest: urlRequest, expectedUrlRequest: expectedUrlRequest)
		}

		// MARK: Act
		_ = try await client.send(
			request,
			delegate: .standard(sending: sending)
		)
	}

	func test_mergingOfUrlClientAndRequestAndSendingConfigurations_equalQueryMerging () async throws {
		// MARK: Arrange
		let request = StandardRequest(
			configuration: .init()
				.queryItems([
					.init(name: "key1", value: "value1"),
					.init(name: "key2", value: "value2"),
				])
		)

		let client = StandardAPIClient(
			configuration: .empty
				.queryItems([
					.init(name: "key1", value: "value1"),
					.init(name: "key2", value: "value2"),
				])
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(
			url: .init(
				string: "?key1=value1&key2=value2&key1=value1&key2=value2&key3=value3"
			)!
		)

		let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
			self.assert(resultUrlRequest: urlRequest, expectedUrlRequest: expectedUrlRequest)
		}

		// MARK: Act
		_ = try await client.send(
			request,
			delegate: .standard(sending: sending),
			configurationUpdate: {
				$0.queryItem(.init(name: "key3", value: "value3"))
			}
		)
	}
}
