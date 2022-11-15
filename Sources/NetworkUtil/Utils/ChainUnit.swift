public typealias ChainUnit<Value> = (_ current: Value, _ next: (Value) throws -> Value) throws -> Value
