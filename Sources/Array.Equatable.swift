import Foundation
import Archivable

#warning("review is used")

extension Array where Element : Equatable {
    func index<T>(element: Element, result: (Int, Self) -> T) -> T {
        firstIndex(of: element)
            .map {
                result($0, self)
            }
        ?? result(count, self + element)
    }
}
