import Foundation

public protocol NetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		encoding: ((Encodable) throws -> Data)?,
    configurationUpdate: URLRequestConfiguration.Update,
		interception: @escaping URLRequestInterception
	) async throws -> RS

	func send <RQ: Request> (
		_ request: RQ,
		encoding: ((Encodable) throws -> Data)?,
    configurationUpdate: URLRequestConfiguration.Update,
		interception: @escaping URLRequestInterception
	) async throws -> StandardResponse

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		encoding: ((Encodable) throws -> Data)?,
    configurationUpdate: URLRequestConfiguration.Update,
		interception: @escaping URLRequestInterception
	) async throws -> StandardModelResponse<RSM>
}

public extension NetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		encoding: ((Encodable) throws -> Data)?,
    configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> StandardResponse {
		try await send(
      request,
      response: StandardResponse.self,
			encoding: encoding,
      configurationUpdate: configurationUpdate,
      interception: interception
    )
	}

	func send <RQ: Request, RSM: ResponseModel> (
		_ request: RQ,
		responseModel: RSM.Type,
		encoding: ((Encodable) throws -> Data)?,
    configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> StandardModelResponse<RSM> {
		try await send(
      request,
      response: StandardModelResponse<RSM>.self,
			encoding: encoding,
      configurationUpdate: configurationUpdate,
      interception: interception
    )
	}
}

public protocol NetworkControllerDecorator: NetworkController {
  var networkController: NetworkController { get }
}

public extension NetworkControllerDecorator {
  func send <RQ: Request, RS: Response> (
    _ request: RQ,
    response: RS.Type,
		encoding: ((Encodable) throws -> Data)?,
    configurationUpdate: URLRequestConfiguration.Update = { $0 },
    interception: @escaping URLRequestInterception = { $0 }
  ) async throws -> RS {
    try await networkController.send(
      request,
      response: response,
			encoding: encoding,
      configurationUpdate: configurationUpdate,
      interception: interception
    )
  }
}
