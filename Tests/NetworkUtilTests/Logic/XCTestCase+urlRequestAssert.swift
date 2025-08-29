import NetworkUtil
import XCTest

extension XCTestCase {
	func assert (resultUrlRequest: URLRequest, expectedUrlRequest: URLRequest) {
		XCTAssertEqual(resultUrlRequest.url, expectedUrlRequest.url)
		XCTAssertEqual(resultUrlRequest.url?.scheme, expectedUrlRequest.url?.scheme)
		XCTAssertEqual(resultUrlRequest.httpMethod, expectedUrlRequest.httpMethod)
		XCTAssertEqual(resultUrlRequest.httpBody, expectedUrlRequest.httpBody)
		XCTAssertEqual(resultUrlRequest, expectedUrlRequest)
	}

	func assert <Body: Encodable> (resultRequest: any Request<Body>, expectedRequest: any Request<Body>) where Body: Equatable {
		XCTAssertEqual(resultRequest.body, expectedRequest.body)
		XCTAssertEqual(resultRequest.configuration, expectedRequest.configuration)
	}
}
