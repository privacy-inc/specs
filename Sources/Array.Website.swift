import Foundation

extension Array where Element == Website {
    func adding(_ element: Element) -> Self {
        [element] + filter {
            $0.id != element.id
        }
    }
    
    func filter(strings: [String]) -> Self {
        map {
            (website: $0, matches: $0.id.rating(components: strings) + $0.title.rating(components: strings))
        }
        .filter {
            $0.matches > 0
        }
        .sorted {
            $0.matches == $1.matches
                ? $0.website.title.localizedCaseInsensitiveCompare($1.website.title) == .orderedAscending
                : $0.matches > $1.matches
        }
        .map(\.website)
    }
}
