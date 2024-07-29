import Foundation

public typealias URLResponseInterception = (Data, URLResponse) throws -> (Data, URLResponse)
