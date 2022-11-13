import Foundation

public struct StandardModelRequest <Model: RequestModel>: ModellableRequest {
	public let method: HTTPMethod
	public let path: String

	public let query: [String: String]
	public let headers: [String: String]

	public let model: Model

	public init (
		method: HTTPMethod = .post,
		path: String,
		query: [String : String] = [:],
		headers: [String : String] = [:],
		model: Model
	) {
		self.method = method
		self.path = path
		self.query = query
		self.headers = headers
		self.model = model
	}
}

public extension StandardModelRequest {
	func set (method: HTTPMethod) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			model: model
		)
	}

	func set (path: String) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			model: model
		)
	}

	func set (query: [String: String]) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			model: model
		)
	}

	func set (headers: [String: String]) -> Self {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			model: model
		)
	}

	func set <NewModel: RequestModel> (model: NewModel) -> StandardModelRequest<NewModel> {
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			model: model
		)
	}
}

public extension Request {
	static func request <RQM: RequestModel> (
		method: HTTPMethod,
		path: String,
		query: [String: String] = [:],
		headers: [String: String] = [:],
		model: RQM
	)
	-> StandardModelRequest<RQM>
	where Self == StandardModelRequest<RQM>
	{
		.init(
			method: method,
			path: path,
			query: query,
			headers: headers,
			model: model
		)
	}

	static func post <RQM: RequestModel> (
		_ path: String,
		query: [String: String] = [:],
		headers: [String: String] = [:],
		model: RQM
	)
	-> StandardModelRequest<RQM>
	where Self == StandardModelRequest<RQM>
	{
		.init(
			method: .post,
			path: path,
			query: query,
			headers: headers,
			model: model
		)
	}
}

