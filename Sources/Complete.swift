import Foundation

public struct Complete: Identifiable {
    public var id: String {
        website.id
    }
    
    public let website: Website
    let matches: Int
}
