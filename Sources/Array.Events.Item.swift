import Foundation
import Archivable

extension Array where Element == Events.Item {
    func index<T>(element: Element, result: (Int, Self) -> T) -> T {
        firstIndex {
            $0.domain == element.domain && $0.timestamp == element.timestamp
        }
        .map {
            result($0, self)
        }
        ?? result(count, self + element)
    }
}
