import NetworkUtil
import Foundation


let urlSession = URLSession(configuration: .default)
let urlRequest = URLRequest(url: .init(string: "https://file-examples.com/wp-content/storage/2017/02/file_example_JSON_1kb.json")!)


let (fileUrl, urlResponse) = try await urlSession.download(for: urlRequest)
print(fileUrl)


func attempts (count: Int) -> SendingDelegate {
	{
		var attemptCount = 0
		var e: Error?

		repeat {
			do {
				return try await $4()
			} catch {
				e = error
				attemptCount += 1
			}
		} while e != nil || attemptCount < count

		throw e!
	}
}

actor AuthNetworkController: FullScaleNetworkControllerDecorator {
	
	
	let networkController: FullScaleNetworkController

	init (networkController: FullScaleNetworkController) {
		self.networkController = networkController
	}
}




// Declare custom network controller
struct AuthenticatedNetworkControllerDecorator: FullScaleNetworkControllerDecorator {
	let networkController: FullScaleNetworkController

	func send<RQ, RS>(
		_ request: RQ,
		response: RS.Type,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> RS.Model)? = nil,
		configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 },
		sendingDelegate: SendingDelegate? = nil
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
				interception: interception,
				sendingDelegate: sendingDelegate
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
let response = try await nc.send(.get(""), sendingDelegate: attempts(count: 3))

