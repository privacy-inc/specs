import Foundation

extension Set where Element == Blocker {
    var rules: String {
        flatMap(\.rules)
            .compress
            .content
    }
}
