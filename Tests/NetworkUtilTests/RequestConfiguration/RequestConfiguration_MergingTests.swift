import Testing
@testable import NetworkUtil
import Foundation

@Suite("RequestConfiguration - merging")
struct RequestConfiguration_MergingTests {
    @Test("Request and client – When different query – Then should be presented all keys")
    func mergingOfApiClientAndRequestConfigurations_differentQueryMerging() async throws {
        // MARK: Arrange
        let request = StandardRequest(
            configuration: .init()
                .queryItems([
                    .init(name: "request.key1", value: "request.value1"),
                    .init(name: "request.key2", value: "request.value2"),
                ])
        )

        let client = StandardAPIClient(
            configuration: .init()
                .queryItems([
                    .init(name: "client.key1", value: "client.value1"),
                    .init(name: "client.key2", value: "client.value2"),
                ])
        )

        // MARK: Assert
        let expectedUrlRequest = URLRequest(
            url: .init(string: "?client.key1=client.value1&client.key2=client.value2&request.key1=request.value1&request.key2=request.value2")!
        )

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // MARK: Act
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending)
        )
    }

    @Test("Request and client – When different query – Then should be presented duplicated keys")
    func mergingOfApiClientAndRequestConfigurations_equalQueryMerging() async throws {
        // MARK: Arrange
        let request = StandardRequest(
            configuration: .init()
                .queryItems([
                    .init(name: "key1", value: "value1"),
                    .init(name: "key2", value: "value2"),
                ])
        )

        let client = StandardAPIClient(
            configuration: .init()
                .queryItems([
                    .init(name: "key1", value: "value1"),
                    .init(name: "key2", value: "value2"),
                ])
        )

        // MARK: Assert
        let expectedUrlRequest = URLRequest(url: .init(string: "?key1=value1&key2=value2&key1=value1&key2=value2")!)

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // MARK: Act
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending)
        )
    }

    @Test("Request, client and sending – When different query – Then should be presented duplicated keys")
    func mergingOfApiClientAndRequestAndSendingConfigurations_equalQueryMerging() async throws {
        // MARK: Arrange
        let request = StandardRequest(
            configuration: .init()
                .queryItems([
                    .init(name: "key1", value: "value1"),
                    .init(name: "key2", value: "value2"),
                ])
        )

        let client = StandardAPIClient(
            configuration: .init()
                .queryItems([
                    .init(name: "key1", value: "value1"),
                    .init(name: "key2", value: "value2"),
                ])
        )

        // MARK: Assert
        let expectedUrlRequest = URLRequest(url: .init(string: "?key1=value1&key2=value2&key1=value1&key2=value2&key3=value3")!)

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
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
