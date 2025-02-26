import NetworkUtil
import Foundation

//StandardURLClient()
//	.repeatable(maxAttempts: 10)
//	.updateConfiguration {
//
//	}
//	.delegate(.standard())

let r = StandardRequest()
    .scheme("https")
    .host("google.com")
    .addPath("test")
    .addQueryItem(.init(name: "qwe", value: "qwe"))
    .addHeader(key: "qwe", value: "qwe")
    .addHeaders([
        "123": "",
        "333": ""
    ])
