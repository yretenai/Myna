import Foundation

internal extension Data {
	@inlinable
	func chunked(into: Int) -> [Data] {
		return stride(from: 0, to: count, by: into).map { startIndex in
			let endIndex = Swift.min(startIndex + into, count)
			return self[startIndex..<endIndex]
		}
	}

	@inlinable
	@inline(__always)
	func xor(other: Data) -> Data {
		return Data(zip(self, other).map { $0 ^ $1 })
	}
}

internal extension Int {
	@inlinable
	@inline(__always)
	func align(into: Int) -> Int {
		return (self + (into - 1)) & ~(into - 1)
	}
}
