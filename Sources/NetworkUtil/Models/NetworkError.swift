import Foundation

public enum NetworkError: NetworkUtilError {
	case preprocessingFailure(Error)
	case networkFailure(URLSession, URLRequest, URLError)
	case postprocessingFailure(Error)
	
	public var error: Error {
		let resultError: Error
		
		switch self {
		case .preprocessingFailure(let error): fallthrough
		case .postprocessingFailure(let error):
			resultError = error
		case .networkFailure(_, _, let error):
			resultError = error
		}
		
		return resultError
	}
}

internal extension NetworkError {
	static func preprocessing (error: Error) -> Self {
        (error as? Self) ?? .preprocessingFailure(error)
	}
	
	static func postprocessing (error: Error) -> Self {
        (error as? Self) ?? .postprocessingFailure(error)
	}
}
