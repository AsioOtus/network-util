import Foundation

public typealias SendAction<RQ: Request> = (
	URLSession,
	URLRequest,
	UUID,
	RQ
) async throws -> (Data, URLResponse)

public typealias SendingDelegate<RQ: Request> = (
	URLSession,
	URLRequest,
	UUID,
	RQ,
	SendAction<RQ>
) async throws -> (Data, URLResponse)

public typealias SendActionTypeErased = (
	URLSession,
	URLRequest,
	UUID
) async throws -> (Data, URLResponse)

public typealias SendingDelegateTypeErased = (
	URLSession,
	URLRequest,
	UUID,
	any Request,
	SendActionTypeErased
) async throws -> (Data, URLResponse)
