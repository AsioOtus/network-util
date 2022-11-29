import Foundation

final class URLRequestInterceptorChain {
	let chainUnit: any URLRequestInterceptor
	let next: URLRequestInterceptorChain?

	init (
		chainUnit: any URLRequestInterceptor,
		next: URLRequestInterceptorChain?
	) {
		self.chainUnit = chainUnit
		self.next = next
	}

	func transform (_ urlRequest: URLRequest) async throws -> URLRequest {
		try await chainUnit.perform(
			urlRequest,
			{ urlRequest in
				guard let next = next else { return urlRequest }
				return try await next.transform(urlRequest)
			}
		)
	}

	static func create (chainUnits: [any URLRequestInterceptor]) -> URLRequestInterceptorChain? {
		var i = chainUnits.reversed().makeIterator()
		var currentContainer: URLRequestInterceptorChain? = nil

		while let nextUnit = i.next() {
			currentContainer = .init(chainUnit: nextUnit, next: currentContainer)
		}

		return currentContainer
	}
}
