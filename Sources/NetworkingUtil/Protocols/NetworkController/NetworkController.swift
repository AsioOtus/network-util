import Combine

public protocol NetworkController {
	func send <RD: RequestDelegate> (_ requestDelegate: RD, source: [String], label: String?) -> AnyPublisher<RD.ContentType, RD.ErrorType>
	func send <RD: RequestDelegate> (_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, RD.ErrorType>
}
