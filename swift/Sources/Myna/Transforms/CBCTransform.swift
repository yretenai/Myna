import Algorithms
import Foundation

/// A block transformation implementation for the Cipher Block Chaining (CBC) mode of operation.
public struct CBCTransform: BlockTransform {
	private let algorithm: SymmetricAlgorithm
	private let padding: PaddingTransform
	private var previousBlock: Data
	private let iv: Data

	init(algorithm: SymmetricAlgorithm, iv: Data?, paddingMode: PaddingTransform?) {
		self.algorithm = algorithm
		self.iv = iv ?? Data(count: self.algorithm.blockSize)
		self.previousBlock = self.iv
		self.padding = paddingMode ?? PKCS7Padding()
	}

	public mutating func encrypt(data: Data) throws -> Data {
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
			self.previousBlock = try self.algorithm.encrypt(block: block.xor(other: previousBlock))
			result.append(previousBlock)
		}

		result.append(try self.algorithm.encrypt(block: finalBlock.xor(other: previousBlock)))

		// reset IV
		previousBlock = iv

		return result
	}

	public mutating func decrypt(data: Data) throws -> Data {
		guard data.count % algorithm.blockSize == 0 else {
			throw MynaError.invalidInputLength
		}

		if data.count == 0 {
			return Data()
		}

		var result = Data(capacity: data.count.align(into: algorithm.blockSize))
		let blocks = data.chunks(ofCount: algorithm.blockSize)

		for block in blocks.dropLast() {
			previousBlock = try self.algorithm.decrypt(block: block).xor(other: previousBlock)
			result.append(previousBlock)
		}

		let finalBlock = try self.algorithm.decrypt(block: blocks.last!).xor(other: previousBlock)
		result.append(try padding.unpad(data: finalBlock))

		// reset IV
		previousBlock = iv

		return result
	}
}
