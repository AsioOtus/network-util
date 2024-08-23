import Foundation

public typealias Decoding<RSM: Decodable> = (Data, URLResponse) throws -> RSM
