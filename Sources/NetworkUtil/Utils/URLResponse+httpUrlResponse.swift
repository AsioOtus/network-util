import Foundation

public extension URLResponse {
    var httpUrlResponse: HTTPURLResponse? { self as? HTTPURLResponse }
}
