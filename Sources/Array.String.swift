import Foundation

extension Array where Element == String {
    var top: Element {
        reduce(into: [:]) {
            $0[$1] = $0[$1, default: 0] + 1
        }
        .max {
            $0.1 < $1.1
        }!
        .0
    }
}
