import Foundation

public protocol ResponseModel: Decodable {
  static func decode (from data: Data) throws -> Self
}
