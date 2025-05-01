import Testing

@testable import NetworkUtil

struct APIClient_decoratingTests {
    let client = StandardAPIClient()
        .configuration {
            $0
                .scheme("http")
                .host("google.com")
                .path("api")
        }

    @Test
    func clientConfiguration_whenDecorated_thenHasDecoratorConfigurationItems () {
        // MARK: Arrange
        struct Decorator: APIClientDecorator {
            var _apiClient: APIClient
            var apiClient: APIClient {
                _apiClient
                    .configuration {
                        $0
                            .scheme("https")
                            .host("github.com")
                    }
            }

            init (apiClient: APIClient) {
                self._apiClient = apiClient
            }
        }

        // MARK: Act
        let decoratedClient = Decorator(apiClient: client)

        // MARK: Assert
        let expectedConfiguration = RequestConfiguration()
            .scheme("https")
            .host("github.com")
            .path("api")

        #expect(decoratedClient.configuration == expectedConfiguration)
    }
}
