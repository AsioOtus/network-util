public protocol NetworkErrorStringConverter {
	func convert (_ error: NetworkError) -> String
}
