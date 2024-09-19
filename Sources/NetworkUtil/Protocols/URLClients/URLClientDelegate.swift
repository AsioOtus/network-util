public protocol URLClientDelegate {
	var urlSessionBuilder: URLSessionBuilder? { get }
	var urlRequestBuilder: URLRequestBuilder? { get }
	var encoder: RequestBodyEncoder? { get }
	var decoder: ResponseModelDecoder? { get }
	var urlRequestsInterceptions: [URLRequestInterception] { get }
	var urlResponsesInterceptions: [URLResponseInterception] { get }
	var sending: AnySending? { get }
}
