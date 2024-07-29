import Foundation

public typealias Decoding<RS: Response> = (Data) throws -> RS.Model
