public protocol ControllerErrorStringConverter {
	func convert (_ error: ControllerError) -> String
}
