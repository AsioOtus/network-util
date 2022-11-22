import Foundation

public protocol URLRequestInterceptor {
	func perform (_ current: URLRequest, _ next: (URLRequest) throws -> URLRequest) throws -> URLRequest
}
