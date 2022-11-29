import Combine

extension Future where Failure == Error {
  convenience init (asyncAction: @escaping () async throws -> Output) {
    self.init { promise in
      Task {
        do {
          let output = try await asyncAction()
          promise(.success(output))
        } catch {
          promise(.failure(error))
        }
      }
    }
  }
}

