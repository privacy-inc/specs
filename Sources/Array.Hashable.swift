import Foundation

extension Array where Element : Hashable {
    func intersection(other: [Element]) -> Set<Element> {
        .init(self)
            .intersection(other)
    }
}
