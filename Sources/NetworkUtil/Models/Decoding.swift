import Foundation

public typealias Decoding<RSM: Decodable> = (Data) throws -> RSM
