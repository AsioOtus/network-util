import Testing

@testable import NetworkUtil

struct URLClient_decoratingTests {
    let client = StandardURLClient()
        .configuration {
            $0
                .scheme("http")
                .host("google.com")
                .path("api")
        }

    @Test
    func clientConfiguration_whenDecorated_thenHasDecoratorConfigurationItems () {
        // MARK: Arrange
        struct Decorator: URLClientDecorator {
            var _urlClient: URLClient
            var urlClient: URLClient {
                _urlClient
                    .configuration {
                        $0
                            .scheme("https")
                            .host("github.com")
                    }
            }

            init (urlClient: URLClient) {
                self._urlClient = urlClient
            }
        }

        // MARK: Act
        let decoratedClient = Decorator(urlClient: client)

        // MARK: Assert
        let expectedConfiguration = RequestConfiguration()
            .scheme("https")
            .host("github.com")
            .path("api")

        #expect(decoratedClient.configuration == expectedConfiguration)
    }
}
