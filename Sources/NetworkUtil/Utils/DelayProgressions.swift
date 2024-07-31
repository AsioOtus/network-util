import Foundation

public enum DelayProgressions {
	public static func zero () -> (Int) -> Int {
		{ _ in 0 }
	}

	public static func constant (_ constant: Int) -> (Int) -> Int {
		{ _ in constant }
	}

	public static func exponent (base: Int = 2) -> (Int) -> Int {
		{ iteration in Int(pow(Double(base), Double(iteration))) }
	}

	public static func geometric (initial: Int, scaleFactor: Int) -> (Int) -> Int {
		{ iteration in initial * Int(pow(Double(scaleFactor), Double(iteration - 1))) }
	}
}
