import Foundation
import Archivable

extension Array where Element == Website {
    func filter(_ element: Element) -> Self {
        let historical = element.id.historical
        return filter {
            $0.id.historical != historical
        }
    }
    
    func prepending(_ element: Element) -> Self {
        element + filter(element)
    }
    
    func appending(_ element: Element) -> Self {
        filter(element) + element
    }
    
    func filter(strings: [String]) -> Self {
        map {
            (website: $0, matches: $0.id.rating(components: strings) + $0.title.rating(components: strings))
        }
        .filter {
            $0.matches > 0
        }
        .sorted { (first: (website: Website, matches: Int), second: (website: Website, matches: Int)) -> Bool in
            first.matches == second.matches
                ? first.website.title.localizedCaseInsensitiveCompare(second.website.title) == .orderedAscending
                : first.matches > second.matches
        }
        .map(\.website)
    }
}
