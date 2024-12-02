import Foundation

public protocol BlockTransform {
	func encrypt(data: Data) throws -> Data
	func decrypt(data: Data) throws -> Data
}
