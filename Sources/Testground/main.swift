import NetworkUtil
import Foundation

let c = RequestConfiguration(
	url: .init(
		query: [
			.init(name: "key", value: nil),
			.init(name: "key", value: nil),
		]
	)
)

let urlRequest = try? StandardURLRequestBuilder().build(nil, c, nil)

print(urlRequest!.url)
