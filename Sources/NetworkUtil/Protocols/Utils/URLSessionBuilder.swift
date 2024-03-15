import Foundation

public protocol URLSessionBuilder {
	func build (_ request: some Request) async throws -> URLSession
}
