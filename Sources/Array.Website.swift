import Foundation

extension Array where Element == Website {
    func adding(_ element: Element) -> Self {
        [element] + filter {
            $0.id != element.id
        }
    }
}
