import Foundation

public struct StandardLogRecordStringConverter: LogRecordStringConverter {
	public var requestInfoConverter: (RequestInfo) -> String
	public var urlRequestConverter: (URLRequest) -> String
	public var urlResponseConverter: (URLResponse, Data) -> String
	public var httpUrlResponseConverter: (HTTPURLResponse, Data) -> String
	public var networkErrorConverter: (NetworkError) -> String
	
	public init (
		requestInfo: @escaping (RequestInfo) -> String,
		urlRequest: @escaping (URLRequest) -> String,
		urlResponse: @escaping (URLResponse, Data) -> String,
		httpUrlResponse: @escaping (HTTPURLResponse, Data) -> String,
		networkError: @escaping (NetworkError) -> String
	) {
		self.requestInfoConverter = requestInfo
		self.urlRequestConverter = urlRequest
		self.urlResponseConverter = urlResponse
		self.httpUrlResponseConverter = httpUrlResponse
		self.networkErrorConverter = networkError
	}
	
	public func convert (_ record: Logger.Record) -> String {
		let requestInfoMessage = requestInfoConverter(record.requestInfo)
		let detailsMessage = convert(record.message)
		
		let messsage = "\(requestInfoMessage) | \(record.requestDelegateName)\n\(detailsMessage)\n"
		return messsage
	}
	
	public func convert (_ message: Logger.Message) -> String {
		let message: String
		
		switch message {
		case .request(_, let urlRequest):
			message = "REQUEST – \(urlRequestConverter(urlRequest))"
		case .response(let data, let httpUrlResponse as HTTPURLResponse):
			message = "RESPONSE – \(httpUrlResponseConverter(httpUrlResponse, data))"
		case .response(let data, let urlResponse):
			message = "RESPONSE – \(urlResponseConverter(urlResponse, data))"
		case .error(let controllerError):
			message = networkErrorConverter(controllerError)
		}
		
		return message
	}
}
