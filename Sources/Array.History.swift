import Foundation

extension Array where Element == History {
    func dropping(_ id: UInt16) -> Self {
        filter {
            $0.id != id
        }
    }
    
    func adding(_ element: Element) -> Self {
        [element] + filter {
            $0.website.access.value != element.website.access.value
        }
    }
}
