import Foundation

public extension Response {
    static func standard <Model> (
        data: Data = .init(),
        urlResponse: URLResponse,
        model: Model
    ) -> Self where Model: Decodable, Self == StandardResponse<Model> {
        .init(data: data, urlResponse: urlResponse, model: model)
    }

    static func standard <Model> (
        data: Data = .init(),
        urlResponse: HTTPURLResponse,
        model: Model
    ) -> Self where Model: Decodable, Self == StandardResponse<Model> {
        .init(data: data, urlResponse: urlResponse, model: model)
    }

    static func standard (
        data: Data = .init(),
        urlResponse: URLResponse
    ) -> Self where Model: Decodable, Self == StandardResponse<Data> {
        .init(data: data, urlResponse: urlResponse, model: data)
    }

    static func standard (
        data: Data = .init(),
        urlResponse: HTTPURLResponse
    ) -> Self where Model: Decodable, Self == StandardResponse<Data> {
        .init(data: data, urlResponse: urlResponse, model: data)
    }
}
