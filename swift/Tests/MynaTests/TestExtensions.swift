import Foundation

extension Data {
	func hex() -> String {
		self.map { String(format: "%02hhx", $0) }.joined()
	}
}
