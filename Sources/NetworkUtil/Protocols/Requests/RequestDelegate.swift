import Foundation

public protocol RequestDelegate <RQM> {
	associatedtype RQM: Encodable

	var encoding: Encoding<RQM>? { get }
	var urlRequestInterception: URLRequestInterception? { get }
	var urlSessionTaskDelegate: URLSessionTaskDelegate? { get }
}
