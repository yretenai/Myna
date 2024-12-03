import Foundation

/// Methods required for transforming data using a block-based transform.
public protocol BlockTransform {
	/// Encrypts the given data.
	///
	/// - Parameter data: The `Data` object to be encrypted. This may be larger than a single block.
	/// - Throws: `MynaError.invalidInputLength` if the input data or padding is invalid.
	/// - Rethrows: Any error thrown by the underlying `SymmetricAlgorithm` or `PaddingTransform`.
	/// - Returns: The encrypted `Data` object.
	func encrypt(data: Data) throws -> Data

	/// Decrypts the given data.
	///
	/// - Parameter data: The `Data` object to be decrypted. This may be larger than a single block.
	/// - Throws: `MynaError.invalidInputLength` if the input data size is not a multiple of the block size.
	/// - Rethrows: Any error thrown by the underlying `SymmetricAlgorithm` or `PaddingTransform`.
	/// - Returns: The decrypted `Data` object.
	func decrypt(data: Data) throws -> Data
}
