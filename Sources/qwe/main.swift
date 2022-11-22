import NetworkUtil

let nc = StandardAsyncNetworkController(basePath: "", interceptors: [
	.compact { $0 }
])
try await nc.send(.get(""), interceptor: CompactURLRequestInterceptor { $0 })

let nc2 = StandardCombineNetworkController(basePath: "")
nc2.send(.get("")) { $0 }
