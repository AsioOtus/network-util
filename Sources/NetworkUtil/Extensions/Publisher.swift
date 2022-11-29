import Combine

extension Publisher {
  func asyncTryMap <T> (
    _ transform: @escaping (Output) async throws -> T
  ) -> Publishers.FlatMap<Future<T, Error>, Publishers.SetFailureType<Self, Error>> {
    self
      .setFailureType(to: Error.self)
      .flatMap { value in Future { try await transform(value) } }
  }
}
