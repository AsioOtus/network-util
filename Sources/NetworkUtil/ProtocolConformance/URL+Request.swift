import Foundation

extension URL: Request {
    public var configuration: RequestConfiguration {
        .init(
            method: .get,
            address: absoluteString
        )
    }
}
