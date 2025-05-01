import Foundation

public protocol Response <Model>: CustomStringConvertible {
	associatedtype Model: Decodable = Data

	var data: Data { get }
	var urlResponse: URLResponse { get }
	var model: Model { get }

	init (data: Data, urlResponse: URLResponse, model: Model)
}

public extension Response {
	var description: String { urlResponse.description }

    public init (data: Data = .init(), urlResponse: HTTPURLResponse, model: Model) {
        self.init(data: data, urlResponse: urlResponse, model: model)
    }

    public init (data: Data = .init(), urlResponse: URLResponse) where Model == Data {
        self.init(data: data, urlResponse: urlResponse, model: data)
    }

    public init (data: Data = .init(), urlResponse: HTTPURLResponse) where Model == Data {
        self.init(data: data, urlResponse: urlResponse, model: data)
    }
}
