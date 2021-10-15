import Foundation

extension Array where Element == Complete {
    mutating func add(website: Website, location: Complete.Location, comparing: [String]) {
        let matches = website.matches(strings: comparing)
        guard matches > 0 else { return }
        
        append(.init(title: website.title,
                     access: website.access,
                     location: location,
                     domain: (website.access as? Access.Remote)?.domain.minimal,
                     matches: matches))
    }
    
    var ordered: Self {
        sorted {
            $0.matches == $1.matches
                ? $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
                : $0.matches > $1.matches
        }
    }
}
