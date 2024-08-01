import Foundation

public enum URLCreationError: NetworkUtilError {
	case urlComponentsFailure(URLComponents)
	case addressFailure(String)
}
