public protocol StandardBuilderInitializable: BuilderInitializable { }

extension StandardBuilderInitializable {
	init (
		urlSessionBuilder: URLSessionBuilder = .standard(),
		scheme: String = "http",
		basePath: String,
		query: [String: String] = [:],
		headers: [String: String] = [:]
	) {
		self.init(
			urlSessionBuilder: urlSessionBuilder,
			urlRequestBuilder: .standard(
				scheme: scheme,
				basePath: basePath,
				query: query,
				headers: headers
			)
		)
	}
}
