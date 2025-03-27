# Network util

Сompact framework for type-safe management of network requests.

Позволяет

0. Создавать общую конфигурацию для всех запросов, включая URL, что невозможно с URLSession.
0. Описывать запросы как отдельные типы данных.
0. Использовать паттерн декоратор, например, для отправки запроса для обновления токена доступа при каждом запросе.
0. Подменять URLClient на мок версию.
0. Логгировать запросы, ошибки и ответы.

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
    let urlClient: URLClient

    func send <RQ, RS> (
        _ request: RQ,
        response: RS.Type,
        delegate: some URLClientSendingDelegate<RQ, RS.Model>,
        configurationUpdate: RequestConfiguration.Update?
    ) async throws -> RS where RS : Response {
        try await urlClient.send(request, response: response, delegate: delegate) {
            let updatedConfiguration = $0.header(key: "Authrorization", value: "token")
            return configurationUpdate?(updatedConfiguration) ?? updatedConfiguration
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
let response = try await authorizedClient.send(request)```
