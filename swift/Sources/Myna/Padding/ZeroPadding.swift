import Foundation

public struct ZeroPadding: PaddingTransform {
	func unpad(data: Data) throws -> Data {
		let remain = data.reversed().count { value in
			value == 0
		}

		guard remain > 0 else {
			throw MynaError.unexpectedPadding
		}

		if remain == data.count {
			return Data()
		}

		return data[...(data.count - Int(remain) - 1)]
	}

	func pad(data: Data, into: Int) throws -> Data {
		var block = Data(capacity: into)
		block.append(data)

		let remain = into - data.count
		if remain <= 0 {
			throw MynaError.invalidInputLength
		}
		block.append(contentsOf: Array(repeating: 0, count: remain))

		return block
	}
}
