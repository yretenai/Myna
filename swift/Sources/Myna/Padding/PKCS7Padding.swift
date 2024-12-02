import Foundation

struct PKCS7Padding: PaddingTransform {
	func unpad(data: Data) throws -> Data {
		if let finalRemain = data.last {
			guard finalRemain != 0 else {
				throw MynaError.unexpectedPadding
			}

			guard finalRemain <= data.count else {
				throw MynaError.unexpectedPadding
			}

			let remain = data.reversed().count { value in
				value == finalRemain
			}

			guard remain == finalRemain else {
				throw MynaError.unexpectedPadding
			}

			if remain == data.count {
				return Data()
			}

			return data[...(data.count - Int(remain) - 1)]
		}

		throw MynaError.unexpectedPadding
	}

	func pad(data: Data, into: Int) throws -> Data {
		var block = Data(capacity: into)
		block.append(data)

		let remain = into - data.count

		if remain <= 0 {
			throw MynaError.invalidInputLength
		}

		block.append(contentsOf: Array(repeating: UInt8(remain), count: remain))
		return block
	}
}
