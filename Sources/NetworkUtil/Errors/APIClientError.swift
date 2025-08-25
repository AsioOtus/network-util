import Foundation

public struct APIClientError: NetworkUtilError {
	public let requestId: UUID?
	public let request: any Request
	public let category: Category
}

public extension APIClientError {
	var innerError: Error { category.innerError }

	var debugName: String { category.debugName }
}

extension APIClientError: LocalizedError {
    public var errorDescription: String? {
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
