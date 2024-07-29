public protocol NetworkControllerSendingDelegate <RQ, RSM> {
	associatedtype RQ: Request
	associatedtype RSM: Decodable

	var encoding: Encoding<RQ>? { get }
	var decoding: Decoding<RSM>? { get }
	var urlRequestInterception: URLRequestInterception? { get }
	var urlResponseInterception: URLResponseInterception? { get }
	var sending: Sending<RQ>? { get }
}
