import Foundation
import Archivable

public struct History: Storable, Identifiable {
    public let id: UInt16
    public let website: Website
    
    public var data: Data {
        .init()
        .adding(id)
        .adding(website)
    }
    
    public init(data: inout Data) {
        self.init(id: data.number(), website: .init(data: &data))
    }
    
    init(id: UInt16, website: Website) {
        self.id = id
        self.website = website
    }
}
