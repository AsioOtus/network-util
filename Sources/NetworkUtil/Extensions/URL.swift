import Foundation

extension URL: Request {
	public func urlRequest () -> URLRequest { .init(url: self) }
}
