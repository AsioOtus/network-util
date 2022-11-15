import Foundation

public protocol URLSessionBuilder {
	func build <R: Request> (_ request: R) throws -> URLSession
}
