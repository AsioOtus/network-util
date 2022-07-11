import Foundation

public enum GeneralError: NetworkUtilError {
	case urlComponnetsCreationFailure(String)
	case urlCreationFailure(URLComponents)
	case urlErrorIsEmpty(Error)
	case urlResponseContentIsEmpty
	case serialTimeout(Error)

	case other(Error)
}

public extension GeneralError {
	static func otherError (_ error: Error) -> Self {
		(error as? Self) ?? .other(error)
	}
}
