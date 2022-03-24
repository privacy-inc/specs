import Foundation

public struct Complete: Identifiable {
    public var id: String {
        location.rawValue + access.value
    }
    
    public let title: String
    public let access: any AccessType
    public let location: Location
    public let domain: String?
    let matches: Int
}
