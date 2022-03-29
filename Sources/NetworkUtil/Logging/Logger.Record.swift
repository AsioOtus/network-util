extension Logger {
    public struct Record {
        public let requestInfo: RequestInfo
        public let requestDelegateName: String
        public let message: Message
    }
}

public extension Logger.Record {
    func convert (_ converter: LogRecordStringConverter) -> String {
        converter.convert(self)
    }
}
