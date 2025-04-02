public protocol RequestWithResponse <RS>: Request {
    associatedtype RS: Response
}
