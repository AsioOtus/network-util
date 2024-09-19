import NetworkUtil
import Foundation

let urlComponents = URLComponents()
	.setQueryItems([
		.init(name: "key1", value: "value1"),
		.init(name: "key2", value: "value2"),
	])
	.addQueryItem(.init(name: "key3", value: "value3"))

dump(urlComponents)

