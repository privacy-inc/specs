import Foundation

extension URL.Scheme {
    enum Policy {
        case
        accept,
        ignore,
        block(String)
    }
}
