import Foundation

public struct Complete: Identifiable {
    public var id: String {
        location.rawValue + website.id
    }
    
    public let website: Website
    public let location: Location
    public let domain: String?
    let matches: Int
}
