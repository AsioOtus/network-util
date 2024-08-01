import Foundation

public typealias Encoding<RQM: Encodable> = (RQM) throws -> Data
