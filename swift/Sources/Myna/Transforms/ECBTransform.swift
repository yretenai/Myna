import Algorithms
import Foundation

/// A block transformation implementation for the Electronic Code Book (ECB) mode of operation.
///
/// - Note: This transform is considered cryptographically unsafe.
public struct ECBTransform: BlockTransform {
	private let algorithm: SymmetricAlgorithm
	private let padding: PaddingTransform

	init(algorithm: SymmetricAlgorithm, paddingMode: PaddingTransform?) {
		self.algorithm = algorithm
		self.padding = paddingMode ?? PKCS7Padding()
	}

	public func encrypt(data: Data) throws -> Data {
		if data.count == 0 {
			return Data()
		}

		var result = Data(capacity: data.count.align(into: algorithm.blockSize))
		var blocks = data.chunks(ofCount: algorithm.blockSize)[...]  // cast to slice.
		var finalBlock: Data
		if data.count % algorithm.blockSize == 0 {
			finalBlock = try padding.pad(data: Data(), into: algorithm.blockSize)
		} else {
			blocks = blocks.dropLast()
			finalBlock = try padding.pad(data: blocks.last!, into: algorithm.blockSize)
		}

		guard finalBlock.count == algorithm.blockSize || finalBlock.count == 0 else {
			throw MynaError.invalidInputLength
		}

		for block in blocks {
			result.append(try self.algorithm.encrypt(block: block))
		}

		result.append(try self.algorithm.encrypt(block: finalBlock))

		return result
	}

	public func decrypt(data: Data) throws -> Data {
		guard data.count % algorithm.blockSize == 0 else {
			throw MynaError.invalidInputLength
		}

		if data.count == 0 {
			return Data()
		}

		var result = Data(capacity: data.count.align(into: algorithm.blockSize))
		let blocks = data.chunks(ofCount: algorithm.blockSize)

		for block in blocks.dropLast() {
			result.append(try self.algorithm.decrypt(block: block))
		}

		let finalBlock = try self.algorithm.decrypt(block: blocks.last!)
		result.append(try padding.unpad(data: finalBlock))
		return result
	}
}