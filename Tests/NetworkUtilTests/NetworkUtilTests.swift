import XCTest
import Combine
@testable import NetworkUtil

var subscriptions = Set<AnyCancellable>()

final class NetworkFlowUtilTests: XCTestCase {
	func test () async throws {
//		let array: [any URLRequestInterceptor] = [
//			{ current, next in print(1); return try next(current) },
//			{ current, next in print(2); return try next(current) },
//			{ current, next in print(3); return try next(current) },
//		]



//		let a = Chain.create(chainUnits: array)
//		try a?.transform(.init(url: .init(string: "localhost")!))

    let urlReq = StandardURLRequestBuilder(address: "") {
      var urlRequest = $0
      urlRequest.timeoutInterval = 1
      return urlRequest
    }

    let nc = StandardCombineNetworkController(urlRequestBuilder: .standard(address: "") { $0 }) { $0 }
//		nc.send(.get("")) { a in
//			return a
//		}
	}
}
