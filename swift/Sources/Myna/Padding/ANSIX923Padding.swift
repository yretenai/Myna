import Foundation

public struct ANSIX923Padding: PaddingTransform {
	public func unpad(data: Data) throws -> Data {
		if let remain = data.last {
			guard remain != 0 else {
				throw MynaError.unexpectedPadding
			}

			guard remain <= data.count else {
				throw MynaError.unexpectedPadding
			}

			guard data.reversed().dropFirst().starts(with: Array(repeating: 0, count: Int(remain) - 1)) else {
				throw MynaError.unexpectedPadding
			}

			if remain == data.count {
				return Data()
			}

			return data[...(data.count - Int(remain) - 1)]
		}

		throw MynaError.unexpectedPadding
	}

	public func pad(data: Data, into: Int) throws -> Data {
		var block = Data(capacity: into)
		block.append(data)

		let remain = into - data.count
		guard remain > 0 else {
			throw MynaError.invalidInputLength
		}

		block.append(contentsOf: Array(repeating: 0, count: remain - 1))
		block.append(UInt8(remain))

		return block
	}
}
