extension RequestConfiguration {
	public struct Method: Hashable {
		public let value: String

		public init (_ value: String) {
			self.value = value.uppercased()
		}
	}
}

extension RequestConfiguration.Method: ExpressibleByStringLiteral {
	public init (stringLiteral: String) {
		self.init(stringLiteral)
	}
}

public extension RequestConfiguration.Method {
	static let get = Self("get")
	static let head = Self("head")
	static let post = Self("post")
	static let put = Self("put")
	static let delete = Self("delete")
	static let connect = Self("connect")
	static let option = Self("option")
	static let trace = Self("trace")
	static let patch = Self("patch")
}
