public protocol NetworkControllerSendingDelegate <RQ, RS> {
	associatedtype RQ: Request
	associatedtype RS: Response

	var encoding: Encoding<RQ>? { get }
	var decoding: Decoding<RS>? { get }
	var urlRequestInterception: URLRequestInterception? { get }
	var urlResponseInterception: URLResponseInterception? { get }
	var sending: Sending<RQ>? { get }
}
