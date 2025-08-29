public protocol RequestWithResponseModel <RSM>: Request {
    associatedtype RSM

    func prepareResponseModel (_ model: RSM) throws -> RSM
}

public extension RequestWithResponseModel {
    func prepareResponseModel (_ model: RSM) throws -> RSM {
        let _: Void = try prepareResponseModel(model)
        return model
    }

    func prepareResponseModel (_ model: RSM) throws { }
}
