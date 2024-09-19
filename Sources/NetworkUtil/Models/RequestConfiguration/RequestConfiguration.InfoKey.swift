extension RequestConfiguration {
	public struct InfoKey: ExpressibleByStringLiteral, Hashable {
		public let name: String

		public init (_ name: String) {
			self.name = name
		}

		public init (stringLiteral name: String) {
			self.name = name
		}
	}
}
