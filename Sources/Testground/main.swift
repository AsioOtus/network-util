import NetworkUtil
import Foundation

StandardURLClient()
	.repeatable(maxAttempts: 10)
//	.configuration {
//        $0.addin
//	}
	.setDelegate(.standard())

let r = StandardRequest()
    .setScheme("https")
    .setHost("google.com")
    .addPath("test")
    .addQueryItem(.init(name: "qwe", value: "qwe"))
    .addHeader(key: "qwe", value: "qwe")
    .addHeaders([
        "123": "",
        "333": ""
    ])
