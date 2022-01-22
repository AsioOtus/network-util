import Combine

public protocol NetworkControllerProtocol {
	func send <RD: RequestDelegate> (_ requestDelegate: RD, source: [String], label: String?) -> AnyPublisher<RD.ContentType, NetworkController.Error>
	func send <RD: RequestDelegate> (_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, NetworkController.Error>
}
