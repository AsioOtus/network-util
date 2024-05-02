import Foundation

public protocol NetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		encoding: ((RQ.Body) throws -> Data)?,
		decoding: ((Data) throws -> RS.Model)?,
		configurationUpdate: URLRequestConfiguration.Update,
		interception: @escaping URLRequestInterception
	) async throws -> RS

	func send <RQ: Request> (
		_ request: RQ,
		encoding: ((RQ.Body) throws -> Data)?,
		decoding: ((Data) throws -> StandardResponse<Data>.Model)?,
    configurationUpdate: URLRequestConfiguration.Update,
		interception: @escaping URLRequestInterception
	) async throws -> StandardResponse<Data>
}

public extension NetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> StandardResponse<Data>.Model)? = nil,
    configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> StandardResponse<Data> {
		try await send(
      request,
      response: StandardResponse<Data>.self,
			encoding: encoding,
			decoding: decoding,
      configurationUpdate: configurationUpdate,
      interception: interception
    )
	}

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> RSM)? = nil,
    configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> StandardResponse<RSM> {
		try await send(
      request,
      response: StandardResponse<RSM>.self,
			encoding: encoding,
			decoding: decoding,
      configurationUpdate: configurationUpdate,
      interception: interception
    )
	}
}
