import Foundation

extension Data {
	@inlinable
	@inline(__always)
	func xor(other: Data) -> Data {
		return Data(zip(self, other).map { $0 ^ $1 })
	}
}

extension Int {
	@inlinable
	@inline(__always)
	func align(into: Int) -> Int {
		return (self + (into - 1)) & ~(into - 1)
	}
}
