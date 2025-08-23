# Network util

Сompact framework for type-safe management of network requests.

## Basic example:

```swift
// Create a APIClient
// Create an APIClient
let client = StandardAPIClient()

// Send request
let response = try await client.send(.get("https://api.github.com/user"))
```

## Intermediate example:

```swift
// Create a APIClient
// Create an APIClient
let client = StandardAPIClient()
    .configuration {
        $0
        .scheme("https")
        .host("api.github.com")
            .scheme("https")
            .host("api.github.com")
    }

// Create request
let request = StandardRequest()
    .path("user")

// Send request
let response = try await client.send(request)


```

## Advanced example:

```swift
// Create a APIClient
// Create an APIClient
let client = StandardAPIClient()
    .configuration {
        $0
            .scheme("https")
            .host("api.github.com")
    }

// Declare custom request
struct UserRequest: Request {
    var configuration: RequestConfiguration {
        .init()
        .empty
        .path("user")
    }
}

// Create request
let request = UserRequest()

// Send request
let response = try await client.send(request)

```

## Expert example:

```swift
// Declare custom APIClient decorator
struct AuthenticatedAPIClientDecorator: APIClientDecorator {
    var _apiClient: APIClient
    var apiClient: APIClient {
        _apiClient
            .configuration {
                $0.header(key: "Authrorization", value: "token")
            }
    }
}

// Create a APIClient
// Create an APIClient
let client = StandardAPIClient()
    .configuration {
        $0
            .scheme("https")
            .host("api.github.com")
    }

let authorizedClient = AuthenticatedAPIClientDecorator(apiClient: client)

// Declare custom request
struct UserRequest: Request {
    var configuration: RequestConfiguration {
        .init()
        .empty
        .path("user")
    }
}

// Create request
let request = UserRequest()


// Send request
let response = try await authorizedClient.send(request)
```
