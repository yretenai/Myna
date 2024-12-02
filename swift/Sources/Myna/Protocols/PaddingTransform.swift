import Foundation

public protocol PaddingTransform {
	func unpad(data: Data) throws -> Data
	func pad(data: Data, into: Int) throws -> Data
}
