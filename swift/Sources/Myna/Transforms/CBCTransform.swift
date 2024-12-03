import Algorithms
import Foundation

/// A block transformation implementation for the Cipher Block Chaining (CBC) mode of operation.
public struct CBCTransform: BlockCipherTransform {
	private let algorithm: BlockCipher
	private let padding: PaddingScheme
	private var previousBlock: Data

	init(algorithm: BlockCipher, iv: Data?, paddingMode: PaddingScheme?) {
		self.algorithm = algorithm
		previousBlock = iv ?? Data(count: algorithm.blockSize)
		padding = paddingMode ?? PKCS7Padding()
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
			previousBlock = try algorithm.encrypt(block: block.xor(other: previousBlock))
			result.append(previousBlock)
		}

		result.append(try algorithm.encrypt(block: finalBlock.xor(other: previousBlock)))

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
			previousBlock = try algorithm.decrypt(block: block).xor(other: previousBlock)
			result.append(previousBlock)
		}

		let finalBlock = try algorithm.decrypt(block: blocks.last!).xor(other: previousBlock)
		result.append(try padding.unpad(data: finalBlock))

		return result
	}
}
