import Testing
@testable import NetworkUtil
import Foundation

@Suite("RequestConfiguration - merging")
struct RequestConfiguration_MergingTests {
    @Test("Request and client – When different query – Then should be presented all keys")
    func mergingOfApiClientAndRequestConfigurations_differentQueryMerging() async throws {
        // Given
        let client = StandardAPIClient(
            configuration: .init()
                .queryItems([
                    .init(name: "client.key1", value: "client.value1"),
                    .init(name: "client.key2", value: "client.value2"),
                ])
        )

        let request = StandardRequest(
            configuration: .init()
                .queryItems([
                    .init(name: "request.key1", value: "request.value1"),
                    .init(name: "request.key2", value: "request.value2"),
                ])
        )

        // Then
        let expectedUrlRequest = URLRequest(
            url: .init(string: "?client.key1=client.value1&client.key2=client.value2&request.key1=request.value1&request.key2=request.value2")!
        )

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // When
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending)
        )
    }

    @Test("Request and client – When different query – Then should be presented duplicated keys")
    func mergingOfApiClientAndRequestConfigurations_equalQueryMerging() async throws {
        // Given
        let client = StandardAPIClient(
            configuration: .init()
                .queryItems([
                    .init(name: "key1", value: "value1"),
                    .init(name: "key2", value: "value2"),
                ])
        )

        let request = StandardRequest(
            configuration: .init()
                .queryItems([
                    .init(name: "key1", value: "value1"),
                    .init(name: "key2", value: "value2"),
                ])
        )

        // Then
        let expectedUrlRequest = URLRequest(url: .init(string: "?key1=value1&key2=value2&key1=value1&key2=value2")!)

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // When
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending)
        )
    }

    @Test("Request, client and sending – When different query – Then should be presented duplicated keys")
    func mergingOfApiClientAndRequestAndSendingConfigurations_equalQueryMerging() async throws {
        // Given
        let client = StandardAPIClient(
            configuration: .init()
                .queryItems([
                    .init(name: "key1", value: "value1"),
                    .init(name: "key2", value: "value2"),
                ])
        )

        let request = StandardRequest(
            configuration: .init()
                .queryItems([
                    .init(name: "key1", value: "value1"),
                    .init(name: "key2", value: "value2"),
                ])
        )

        // Then
        let expectedUrlRequest = URLRequest(url: .init(string: "?key1=value1&key2=value2&key1=value1&key2=value2&key3=value3")!)

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // When
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending),
            configurationUpdate: {
                $0.queryItem(.init(name: "key3", value: "value3"))
            }
        )
    }

    @Test("Request and client – When different headers – Then should present all headers")
    func mergingOfApiClientAndRequestHeaders_differentHeaders() async throws {
        // Given
        let client = StandardAPIClient(
            configuration: .init()
                .header(key: "client.key1", value: "client.value1")
                .header(key: "client.key2", value: "client.value2")
        )

        let request = StandardRequest(
            configuration: .init()
                .header(key: "request.key1", value: "request.value1")
                .header(key: "request.key2", value: "request.value2")
        )

        // Then
        var expectedUrlRequest = URLRequest(url: URLComponents().url!)
        expectedUrlRequest.setValue("client.value1", forHTTPHeaderField: "client.key1")
        expectedUrlRequest.setValue("client.value2", forHTTPHeaderField: "client.key2")
        expectedUrlRequest.setValue("request.value1", forHTTPHeaderField: "request.key1")
        expectedUrlRequest.setValue("request.value2", forHTTPHeaderField: "request.key2")

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // When
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending)
        )
    }

    @Test("Request and client – When same header keys – Then request overrides client")
    func mergingOfApiClientAndRequestHeaders_equalKeys() async throws {
        // Given
        let client = StandardAPIClient(
            configuration: .init()
                .header(key: "key1", value: "value1")
                .header(key: "key2", value: "value2")
        )

        let request = StandardRequest(
            configuration: .init()
                .header(key: "key1", value: "value1")
                .header(key: "key2", value: "value2")
        )

        // Then
        var expectedUrlRequest = URLRequest(url: URLComponents().url!)
        expectedUrlRequest.setValue("value1", forHTTPHeaderField: "key1")
        expectedUrlRequest.setValue("value2", forHTTPHeaderField: "key2")

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // When
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending)
        )
    }

    @Test("Request, client and sending – When headers merged with closure – Then include closure header")
    func mergingOfApiClientAndRequestAndSendingHeaders_equalMerging() async throws {
        // Given
        let client = StandardAPIClient(
            configuration: .init()
                .header(key: "key1", value: "value1")
                .header(key: "key2", value: "value2")
        )

        let request = StandardRequest(
            configuration: .init()
                .header(key: "key3", value: "value3")
                .header(key: "key4", value: "value4")
        )

        // Then
        var expectedUrlRequest = URLRequest(url: URLComponents().url!)
        expectedUrlRequest.setValue("value1", forHTTPHeaderField: "key1")
        expectedUrlRequest.setValue("value2", forHTTPHeaderField: "key2")
        expectedUrlRequest.setValue("value3", forHTTPHeaderField: "key3")
        expectedUrlRequest.setValue("value4", forHTTPHeaderField: "key4")
        expectedUrlRequest.setValue("value5", forHTTPHeaderField: "key5")

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // When
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending),
            configurationUpdate: {
                $0.header(key: "key5", value: "value5")
            }
        )
    }

    @Test("Request, client and sending – When headers merged with closure – Then add closure header")
    func mergingOfApiClientAndRequestAndSendingSetHeaders_equalMerging() async throws {
        // Given
        let client = StandardAPIClient(
            configuration: .init()
                .header(key: "key1", value: "value1")
                .header(key: "key2", value: "value2")
        )

        let request = StandardRequest(
            configuration: .init()
                .header(key: "key3", value: "value3")
                .header(key: "key4", value: "value4")
        )

        // Then
        var expectedUrlRequest = URLRequest(url: URLComponents().url!)
        expectedUrlRequest.setValue("value5", forHTTPHeaderField: "key5")

        let sending: Sending<StandardRequest<Data>> = mockSending { urlRequest in
            #expect(urlRequest == expectedUrlRequest)
        }

        // When
        _ = try await client.send(
            request,
            delegate: .standard(sending: sending),
            configurationUpdate: {
                $0.setHeader(key: "key5", value: "value5")
            }
        )
    }
}
