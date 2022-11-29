import Foundation

public protocol URLRequestInterceptor {
	func perform (_ current: URLRequest, _ next: (URLRequest) async throws -> URLRequest) async throws -> URLRequest
}
