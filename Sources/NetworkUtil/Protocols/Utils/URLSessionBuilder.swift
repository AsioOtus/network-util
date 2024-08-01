import Foundation

public protocol URLSessionBuilder {
	func build (_: some Request) throws -> URLSession
}
