import Foundation

public protocol JSONResponseModel: ResponseModel { }

public extension JSONResponseModel {
  static func decode (from data: Data) throws -> Self {
    try JSONDecoder().decode(Self.self, from: data)
  }
}
