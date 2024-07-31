import Foundation

public typealias SendAction<RQ: Request> = (
	URLSession,
	URLRequest,
	UUID,
	RQ
) async throws -> (Data, URLResponse)

public typealias Sending<RQ: Request> = (
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

public typealias SendingTypeErased = (
	URLSession,
	URLRequest,
	UUID,
	any Request,
	SendActionTypeErased
) async throws -> (Data, URLResponse)

func defaultSending <RQ: Request> () -> Sending<RQ> {
	{ try await $4($0, $1, $2, $3) }
}

func defaultSendingTypeErased () -> SendingTypeErased {
	{ try await $4($0, $1, $2) }
}
