import Foundation

public struct URLClientError: NetworkUtilError {
	public let requestId: UUID?
	public let request: any Request
	public let category: Category
}

public extension URLClientError {
	var innerError: Error { category.innerError }

	var debugName: String { category.debugName }
}

extension URLClientError: LocalizedError {
    public var errorDescription: String {
        [
            debugName,
            request.name,
            requestId?.uuidString ?? nil,
            category.localizedDescription
        ]
        .compactMap { $0 }
        .joined(separator: " | ")
    }
}
