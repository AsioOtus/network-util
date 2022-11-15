public protocol StandardBuilderInitializable: BuilderInitializable { }

extension StandardBuilderInitializable {
	init (
		urlSessionBuilder: URLSessionBuilder = .standard(),
		scheme: @escaping @autoclosure () -> String = "http",
		basePath: @escaping @autoclosure () -> String,
		query: @escaping @autoclosure () -> [String: String] = [:],
		headers: @escaping @autoclosure () -> [String: String] = [:]
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
