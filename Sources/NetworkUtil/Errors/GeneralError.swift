import Foundation

public enum GeneralError: NetworkUtilError {
	case urlComponentsCreationFailure(String)
	case urlCreationFailure(URLComponents)
	case urlCreationFailure(address: String)

	case other(Error)
}

public extension GeneralError {
	static func otherError (_ error: Error) -> Self {
		(error as? Self) ?? .other(error)
	}
}
