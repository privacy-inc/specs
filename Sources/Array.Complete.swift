import Foundation

extension Array where Element == Complete {
    mutating func add(website: Website, comparing: [String]) {
        let matches = website.matches(strings: comparing)
        
        guard matches > 0 else { return }
        
        append(.init(website: website,
                     matches: matches))
    }
    
    var ordered: Self {
        sorted {
            $0.matches == $1.matches
                ? $0.website.title.localizedCaseInsensitiveCompare($1.website.title) == .orderedAscending
                : $0.matches > $1.matches
        }
    }
}
