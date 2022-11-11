public protocol ModellableResponse: Response {
	associatedtype Model: ResponseModel

	var model: Model { get }
}
