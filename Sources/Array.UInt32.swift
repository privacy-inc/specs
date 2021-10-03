import Foundation
import Archivable

extension Array where Element == UInt32 {
    func timestamp<T>(result: (Int, Self) -> T) -> T {
        last
            .flatMap {
                .init(timestamp: $0) > Calendar.current.date(byAdding: .minute, value: -1, to: .now)!
                ? count - 1
                : nil
            }
            .map {
                result($0, self)
            }
        ?? result(count, self + .now)
    }
}
