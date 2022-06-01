import Foundation

extension URL: RequestDelegate {
    public var name: String { "\(Self.self)" }
    
    public func request (_ requestInfo: RequestInfo) -> URLRequest { .init(url: self) }
}
