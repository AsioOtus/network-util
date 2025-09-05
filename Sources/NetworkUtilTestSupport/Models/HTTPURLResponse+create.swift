import Foundation

public extension HTTPURLResponse {
    static func create (
        url: URL = .init(string: "stub")!,
        statusCode: Int,
        httpVersion: String? = nil,
        headerFields: [String : String]? = [:]
    ) -> HTTPURLResponse? {
        HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headerFields
        )
    }
}
