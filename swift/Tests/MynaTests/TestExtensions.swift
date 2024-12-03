import Foundation

extension Data {
	func hex() -> String {
		map { String(format: "%02hhx", $0) }.joined()
	}
}
