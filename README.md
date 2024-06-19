# Network util

Сompact framework for type-safe management of network requests.

## Basic example:

```swift
// Create a network controller
let nc = StandardNetworkController(configuration: .init(address: "api.github.com"))

// Send request
let response = try await nc.send(.get("user"))
```

## Intermediate example:

```swift
// Create a network controller
let nc = StandardNetworkController(configuration: .init(address: "api.github.com"))

// Create request
let request = StandardRequest(path: "user")

// Send request
let response = try await nc.send(request)
```

## Advanced example:

```swift
// Create a network controller
let nc = StandardNetworkController(configuration: .init(address: "api.github.com"))

// Declare custom request
struct UserRequest: Request {
	var path: String { "user" }
	var body: Data? { nil }
}

// Create request
let request = UserRequest()

// Send request
let response = try await nc.send(request)
```

## Expert example:

```swift
// Declare custom network controller decorator
struct AuthenticatedNetworkControllerDecorator: FullScaleNetworkControllerDecorator {
	let networkController: FullScaleNetworkController

	func send<RQ, RS>(
		_ request: RQ,
		response: RS.Type,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> RS.Model)? = nil,
		configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> RS where RQ: NetworkUtil.Request, RS: NetworkUtil.Response {
		try await networkController
			.send(
				request,
				response: response,
				encoding: encoding,
				decoding: decoding,
				configurationUpdate: {
					$0.addHeader(key: "Authorization", value: "Bearer token")
				},
				interception: interception
			)
	}
}

// Create a network controller
let nc = AuthenticatedNetworkControllerDecorator(
	networkController: StandardNetworkController(configuration: .init(address: "api.github.com"))
)

// Declare custom request
struct UserRequest: Request {
	var path: String { "user" }
	var body: Data? { nil }
}

// Create request
let request = UserRequest()

// Send request
let response = try await nc.send(request)
```
