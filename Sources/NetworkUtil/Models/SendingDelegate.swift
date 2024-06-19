import Foundation

public typealias SendAction = () async throws -> (Data, URLResponse)

public typealias SendingDelegate = (
	URLSession,
	URLRequest,
	UUID,
	any Request,
	SendAction
) async throws -> (Data, URLResponse)
