import Foundation

public typealias Encoding<RQ: Request> = (RQ.Body) throws -> Data
