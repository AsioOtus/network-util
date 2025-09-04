import Foundation

extension JSONDecoder: ResponseModelDecoder { 
	public func decode <T> (
		_ type: T.Type,
		from data: Data,
		urlResponse: URLResponse
	) throws -> T where T : Decodable {
		try decode(type, from: data)
	}
}
