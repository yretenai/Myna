import Foundation

public protocol SymmetricAlgorithm {
	var blockSize: Int { get }
	func encrypt(block: Data) throws -> Data
	func decrypt(block: Data) throws -> Data
}
