import Foundation

public struct NoPadding: PaddingTransform {
	public func unpad(data: Data) throws -> Data {
		return data
	}

	public func pad(data: Data, into: Int) throws -> Data {
		guard data.count == into || data.count == 0 else {
			throw MynaError.invalidInputLength
		}

		return data
	}
}
