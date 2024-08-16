import NetworkUtil
import Foundation

let nc = StandardNetworkController(
	configuration: .init(
		url: .http(host: "google.com")
	),
	delegate: .standard()
		.addUrlResponseInterception {
			if ($1 as? HTTPURLResponse)?.statusCode != 200 {
				throw ""
			}
			return ($0, $1)
		}
)

_ = try await nc.send(
	.get()
)

class TestDelegate: NSObject, URLSessionTaskDelegate {
	static let test = "123"

	func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
		print(#function)
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
		dump(metrics)
	}
}

extension String: Error { }
