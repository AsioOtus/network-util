import XCTest
import Combine
@testable import NetworkUtil

var subscriptions = Set<AnyCancellable>()

final class NetworkFlowUtilTests: XCTestCase {
	func test () async throws {
		let controller = StandardAsyncNetworkController(configuration: .empty)
			.withConfiguration {
				$0.addHeader(key: "auth", value: "token")
			}
	}
}
