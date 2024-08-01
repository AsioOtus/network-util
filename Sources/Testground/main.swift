import NetworkUtil
import Foundation

// Declare custom network controller decorator
struct AuthenticatedNetworkControllerDecorator: NetworkControllerDecorator {
	let networkController: NetworkController

	func send <RQ, RS> (
		_ request: RQ,
		response: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS where RS : Response {
		try await networkController.send(request, response: response, delegate: delegate) {
			let updatedConfiguration = $0.addHeader(key: "Authrorization", value: "token")
			return configurationUpdate?(updatedConfiguration) ?? updatedConfiguration
		}
	}
}

// Create a network controller
let nc = StandardNetworkController(
	configuration: .init(
		url: .init(
			scheme: "https",
			host: "api.github.com"
		)
	)
)

let authorizedNC = AuthenticatedNetworkControllerDecorator(
	networkController: nc
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


print(response.data)
