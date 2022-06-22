import Foundation

public struct StandardNetworkErrorStringConverter: ControllerErrorStringConverter {
	public var urlRequestConverter: (URLRequest) -> String
	public var urlErrorConverter: (URLError) -> String

	public init (
		urlRequestConverter: @escaping (URLRequest) -> String,
		urlErrorConverter: @escaping (URLError) -> String
	) {
		self.urlRequestConverter = urlRequestConverter
		self.urlErrorConverter = urlErrorConverter
	}

	public func convert (_ error: ControllerError) -> String {
        "\(error.name.uppercased()) ERROR – \(error.innerError)"
	}
}
