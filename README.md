# Network util

Сompact framework for type-safe management of network requests.

## Basic example:

```swift
// Create a URLClient
let nc = StandardURLClient()

// Send request
let response = try await nc.send(.get("https://api.github.com/user"))
```

## Intermediate example:

```swift
// Create a URLClient
let nc = StandardURLClient(
	configuration: .init(
		url: .init(
			scheme: "https",
			host: "api.github.com"
		)
	)
)

// Create request
let request = StandardRequest()
	.configuration {
		$0.setPath("user")
	}

// Send request
let response = try await nc.send(request)

```

## Advanced example:

```swift
// Create a URLClient
let nc = StandardURLClient(
	configuration: .init(
		url: .init(
			scheme: "https",
			host: "api.github.com"
		)
	)
)

// Declare custom request
struct UserRequest: Request {
	var configuration: RequestConfiguration {
		.init()
		.setPath("user")
	}
}

// Create request
let request = UserRequest()

// Send request
let response = try await nc.send(request)
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
			let updatedConfiguration = $0.addHeader(key: "Authrorization", value: "token")
			return configurationUpdate?(updatedConfiguration) ?? updatedConfiguration
		}
	}
}

// Create a URLClient
let nc = StandardURLClient(
	configuration: .init(
		url: .init(
			scheme: "https",
			host: "api.github.com"
		)
	)
)

let authorizedNC = AuthenticatedURLClientDecorator(
	urlClient: nc
)

// Declare custom request
struct UserRequest: Request {
	var configuration: RequestConfiguration {
		.init()
		.setPath("user")
	}
}

// Create request
let request = UserRequest()


// Send request
let response = try await authorizedNC.send(request)
```
