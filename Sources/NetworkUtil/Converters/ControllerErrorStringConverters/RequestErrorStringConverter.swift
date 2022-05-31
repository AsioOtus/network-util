public protocol RequestErrorStringConverter {
	func convert (_ error: RequestError) -> String
}
