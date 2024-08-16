import Foundation

public protocol NetworkControllerSendingDelegate <RQ, RSM> {
	associatedtype RQ: Request
	associatedtype RSM: Decodable

	var encoding: Encoding<RQ.Body>? { get }
	var decoding: Decoding<RSM>? { get }
	var urlRequestInterceptions: [URLRequestInterception] { get }
	var urlResponseInterceptions: [URLResponseInterception] { get }
	var urlSessionTaskDelegate: URLSessionTaskDelegate? { get }
	var sending: Sending<RQ>? { get }
}
