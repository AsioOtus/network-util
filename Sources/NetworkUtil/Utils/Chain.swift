final class Chain <Value> {
	let chainUnit: ChainUnit<Value>
	let next: Chain?

	init (
		chainUnit: @escaping ChainUnit<Value>,
		next: Chain?
	) {
		self.chainUnit = chainUnit
		self.next = next
	}

	func transform (_ value: Value) throws -> Value {
		try chainUnit(
			value,
			{ value in
				guard let next = next else { return value }
				return try next.transform(value)
			}
		)
	}
}

extension Chain {
	static func create(chainUnits: [ChainUnit<Value>]) -> Chain<Value>? {
		var i = chainUnits.reversed().makeIterator()
		var currentContainer: Chain<Value>? = nil

		while let nextUnit = i.next() {
			currentContainer = .init(chainUnit: nextUnit, next: currentContainer)
		}

		return currentContainer
	}
}
