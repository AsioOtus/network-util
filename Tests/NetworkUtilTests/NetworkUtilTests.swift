import XCTest
import Combine
@testable import NetworkUtil

public struct Model: Codable {
	public static let dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss.SSSS"
		return dateFormatter
	}()
	
	public let date: String
	public let timestamp: Double
	public let info: [String: String]?
	public let processId: String
	
	public init (date: Date, info: [String: String]?, processId: String) {
		self.date = Self.dateFormatter.string(from: date)
		self.timestamp = date.timeIntervalSince1970
		self.info = info
		self.processId = processId
	}
}

final class NetworkFlowUtilTests: XCTestCase {
//	var cancellables = Set<AnyCancellable>()
	
	func test () {
		let c = StandardNativeNetworkController()
		CustomDelegate(request: URL(string: "")!)
		.on(
			response: StandardResponse.init,
			content: { $0 }
		)
		.on(error: { $0 })
	}
}
