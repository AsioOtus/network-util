import Foundation

public protocol NetworkController {
	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		encoding: ((RQ.Body) throws -> Data)?,
		decoding: ((Data) throws -> RS.Model)?,
		configurationUpdate: URLRequestConfiguration.Update?,
		interception: URLRequestInterception?,
		sendingDelegate: SendingDelegate<RQ>?
	) async throws -> RS

	func send <RQ: Request> (
		_ request: RQ,
		encoding: ((RQ.Body) throws -> Data)?,
		decoding: ((Data) throws -> StandardResponse<Data>.Model)?,
    configurationUpdate: URLRequestConfiguration.Update?,
		interception: URLRequestInterception?,
		sendingDelegate: SendingDelegate<RQ>?
	) async throws -> StandardResponse<Data>

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		encoding: ((RQ.Body) throws -> Data)?,
		decoding: ((Data) throws -> RSM)?,
		configurationUpdate: URLRequestConfiguration.Update?,
		interception: URLRequestInterception?,
		sendingDelegate: SendingDelegate<RQ>?
	) async throws -> StandardResponse<RSM>
}

public extension NetworkController {
	func send <RQ: Request> (
		_ request: RQ,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> StandardResponse<Data>.Model)? = nil,
    configurationUpdate: URLRequestConfiguration.Update? = nil,
		interception: URLRequestInterception? = nil,
		sendingDelegate: SendingDelegate<RQ>? = nil
	) async throws -> StandardResponse<Data> {
		try await send(
      request,
      response: StandardResponse<Data>.self,
			encoding: encoding,
			decoding: decoding,
      configurationUpdate: configurationUpdate,
      interception: interception,
			sendingDelegate: sendingDelegate
    )
	}

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM.Type,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> RSM)? = nil,
    configurationUpdate: URLRequestConfiguration.Update? = nil,
		interception: URLRequestInterception? = nil,
		sendingDelegate: SendingDelegate<RQ>? = nil
	) async throws -> StandardResponse<RSM> {
		try await send(
      request,
      response: StandardResponse<RSM>.self,
			encoding: encoding,
			decoding: decoding,
      configurationUpdate: configurationUpdate,
      interception: interception,
			sendingDelegate: sendingDelegate
    )
	}
}
