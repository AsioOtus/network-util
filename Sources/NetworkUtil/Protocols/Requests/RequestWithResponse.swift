public protocol RequestWithResponse <RS>: Request {
    associatedtype RS: Response

    func prepareResponse (_ response: RS) throws -> RS
}

public extension RequestWithResponse {
    func prepareResponse (_ response: RS) throws -> RS {
        let _: Void = try prepareResponse(response)
        return response
    }

    func prepareResponse (_ response: RS) throws { }
}
