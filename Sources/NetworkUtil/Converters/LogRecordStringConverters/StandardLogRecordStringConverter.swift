import Foundation

@available(iOS 13.0, *)
public struct StandardLogRecordStringConverter: LogRecordStringConverter {
	public var requestInfoConverter: (RequestInfo) -> String
	public var urlRequestConverter: (URLRequest) -> String
	public var urlResponseConverter: (URLResponse, Data) -> String
	public var httpUrlResponseConverter: (HTTPURLResponse, Data) -> String
	public var requestErrorConverter: (ControllerError) -> String

	public init (
		requestInfo: @escaping (RequestInfo) -> String,
		urlRequest: @escaping (URLRequest) -> String,
		urlResponse: @escaping (URLResponse, Data) -> String,
		httpUrlResponse: @escaping (HTTPURLResponse, Data) -> String,
		requestError: @escaping (ControllerError) -> String
	) {
		self.requestInfoConverter = requestInfo
		self.urlRequestConverter = urlRequest
		self.urlResponseConverter = urlResponse
		self.httpUrlResponseConverter = httpUrlResponse
		self.requestErrorConverter = requestError
	}

	public func convert (_ record: LogRecord) -> String {
		let requestInfoMessage = requestInfoConverter(record.requestInfo)
		var messsage = "\(requestInfoMessage) | \(record.requestInfo.delegate)\n"

		if let detailsMessage = convert(record.message) {
			messsage.append("\n\(detailsMessage)")
		}

		return messsage
	}

	public func convert (_ loggerMessage: LogMessage) -> String? {
		let message: String

		switch loggerMessage {
		case .request(_, let urlRequest):
			message = "REQUEST – \(urlRequestConverter(urlRequest))"
		case .response(let data, let httpUrlResponse as HTTPURLResponse):
			message = "RESPONSE – \(httpUrlResponseConverter(httpUrlResponse, data))"
		case .response(let data, let urlResponse):
			message = "RESPONSE – \(urlResponseConverter(urlResponse, data))"
		case .error(let controllerError):
			message = requestErrorConverter(controllerError)
		}

		return message
	}
}
