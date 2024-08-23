import Foundation

public typealias Decoding<RSM: Decodable> = (Data, URLResponse, ResponseModelDecoder) throws -> RSM
