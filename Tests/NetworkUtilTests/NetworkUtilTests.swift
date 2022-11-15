import XCTest
import Combine
@testable import NetworkUtil

var subscriptions = Set<AnyCancellable>()

final class NetworkFlowUtilTests: XCTestCase {
	func test () async throws {

		let array: [URLRequestInterceptor] = [
			{ current, next in print(1); return try next(current) },
			{ current, next in print(2); return try next(current) },
			{ current, next in print(3); return try next(current) },
		]

		

		let a = Chain.create(chainUnits: array)
		try a?.transform(.init(url: .init(string: "localhost")!))
	}
}
