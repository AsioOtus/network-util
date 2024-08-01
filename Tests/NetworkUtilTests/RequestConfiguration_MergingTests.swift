import XCTest
@testable import NetworkUtil

final class RequestConfiguration_MergingTests: XCTestCase {
	func test_mergingOfControllerAndRequestConfigurations_differentQueryMerging () async throws {
		// MARK: Arrange
		let request = StandardRequest(
			configuration: .init()
				.setQuery([
					.init(name: "request.key1", value: "request.value1"),
					.init(name: "request.key2", value: "request.value2"),
				])
		)

		let nc = StandardNetworkController(
			configuration: .empty
				.setQuery([
					.init(name: "controller.key1", value: "controller.value1"),
					.init(name: "controller.key2", value: "controller.value2"),
				])
		)

		// MARK: Assert
		let expectedUrlRequest = URLRequest(
			url: .init(
				string: "?controller.key1=controller.value1&controller.key2=controller.value2&request.key1=request.value1&request.key2=request.value2"
			)!
		)

		let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
			self.assert(resultUrlRequest: urlRequest, expectedUrlRequest: expectedUrlRequest)
		}

		// MARK: Act
		_ = try await nc.send(
			request,
			delegate: .standard(sending: sending)
		)
	}

	func test_mergingOfControllerAndRequestConfigurations_equalQueryMerging () async throws {
		// MARK: Arrange
		let request = StandardRequest(
			configuration: .init()
				.setQuery([
					.init(name: "key1", value: "value1"),
					.init(name: "key2", value: "value2"),
				])
		)

		let nc = StandardNetworkController(
			configuration: .empty
				.setQuery([
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
		_ = try await nc.send(
			request,
			delegate: .standard(sending: sending)
		)
	}

	func test_mergingOfControllerAndRequestAndSendingConfigurations_equalQueryMerging () async throws {
		// MARK: Arrange
		let request = StandardRequest(
			configuration: .init()
				.setQuery([
					.init(name: "key1", value: "value1"),
					.init(name: "key2", value: "value2"),
				])
		)

		let nc = StandardNetworkController(
			configuration: .empty
				.setQuery([
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
		_ = try await nc.send(
			request,
			delegate: .standard(sending: sending),
			configurationUpdate: {
				$0.addQuery(.init(name: "key3", value: "value3"))
			}
		)
	}
}
