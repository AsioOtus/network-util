import Foundation

struct DecodingDecorator: URLClientDecorator {
	let urlClient: URLClient

	func send <RQ: Request, RSM: Decodable> (
		_ request: RQ,
		responseModel: RSM?.Type,
		delegate: some URLClientSendingDelegate<RQ, RSM>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RSM? {
		let response = try await urlClient.send(
			request,
			response: StandardResponse<Data>.self,
			delegate: .standard(
				encoding: delegate.encoding,
				decoding: nil,
				urlRequestInterceptions: delegate.urlRequestInterceptions,
				urlResponseInterceptions: delegate.urlResponseInterceptions,
				urlSessionTaskDelegate: delegate.urlSessionTaskDelegate,
				sending: delegate.sending
			),
			configurationUpdate: configurationUpdate
		)

		return if response.httpUrlResponse?.statusCode == 200 {
			if let decoding = delegate.decoding {
				try decoding(response.data, response.urlResponse, urlClient.delegate.decoder ?? StandardURLClient.defaultDecoder)
			} else {
				try urlClient.delegate.decoder?.decode(
					RSM.self,
					from: response.data,
					urlResponse: response.urlResponse
				)
			}
		} else {
			nil
		}
	}
}
