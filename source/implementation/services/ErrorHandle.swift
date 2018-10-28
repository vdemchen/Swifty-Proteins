import Foundation

enum ErrorHandle {
    case success(Success)
    case error(Error)
}

struct Success {
    let value: [String]
}

struct Error {
    let value: String
}
