import Foundation

public struct Complete: Identifiable {
    public var id: String {
        access.value
    }
    
    public let title: String
    public let access: AccessType
    public let location: Location
    public let domain: String?
    let matches: Int
    
    static func bookmark(title: String, access: AccessType, domain: String?) -> Self {
        .init(title: title, access: access, location: .bookmark, domain: domain, matches: 1)
    }
    
    static func history(title: String, access: AccessType, domain: String?) -> Self {
        .init(title: title, access: access, location: .history, domain: domain, matches: 1)
    }
    
    private init(title: String, access: AccessType, location: Location, domain: String?, matches: Int) {
        self.title = title
        self.access = access
        self.location = location
        self.domain = domain
        self.matches = matches
    }
    
    var matched: Self {
        .init(title: title, access: access, location: location, domain: domain, matches: matches + 1)
    }
}
