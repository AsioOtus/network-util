# Network util

Сompact framework for type-safe management of network requests.

## Basic example:

```swift
// Create a URLClient
let client = StandardURLClient()

// Send request
let response = try await client.send(.get("https://api.github.com/user"))
```

## Intermediate example:

```swift
// Create a URLClient
let client = StandardURLClient()
    .configuration {
        $0
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
// Create a URLClient
let client = StandardURLClient()
    .configuration {
        $0
            .scheme("https")
            .host("api.github.com")
    }

// Declare custom request
struct UserRequest: Request {
    var configuration: RequestConfiguration {
        .init()
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
// Declare custom URLClient decorator
struct AuthenticatedURLClientDecorator: URLClientDecorator {
    var _urlClient: URLClient
    var urlClient: URLClient {
        _urlClient
            .configuration {
                $0.header(key: "Authrorization", value: "token")
            }
    }
}

// Create a URLClient
let client = StandardURLClient()
    .configuration {
        $0
            .scheme("https")
            .host("api.github.com")
    }

let authorizedClient = AuthenticatedURLClientDecorator(urlClient: client)

// Declare custom request
struct UserRequest: Request {
    var configuration: RequestConfiguration {
        .init()
        .path("user")
    }
}

// Create request
let request = UserRequest()


// Send request
let response = try await authorizedClient.send(request)
```
