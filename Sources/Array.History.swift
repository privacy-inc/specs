import Foundation

extension Array where Element == History {
    func adding(_ element: Element) -> Self {
        [element] + filter {
            $0.website.access.value != element.website.access.value
        }
    }
}
