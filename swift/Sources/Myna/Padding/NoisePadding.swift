import Foundation

struct NoisePadding : PaddingTransform {
	func unpad(data: Data) throws -> Data {
		return data
	}

	func pad(data: Data, into: Int) throws -> Data {
		var block = Data(capacity: into)
		block.append(data)
		
		let remain = into - data.count
		guard remain > 0 else {
			throw MynaError.invalidInputLength
		}

		block.append(try Data.random(count: remain))

		return block
	}
}
