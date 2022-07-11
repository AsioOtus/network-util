public struct StandardRequestInfoStringConverter: RequestInfoStringConverter {
	public let componentSeparator: String

	public init (componentSeparator: String = "\n") {
		self.componentSeparator = componentSeparator
	}

	public func convert (_ requestInfo: RequestInfo) -> String {
		var message = "REQUEST UUID – \(requestInfo.uuid.uuidString)"
		requestInfo.label.map { message.append(" | LABEL – \($0)") }
		return message
	}
}

fileprivate extension Array where Element == String {
	func combine (with separator: String) -> String {
		let preparedSources = self.compactMap { $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
