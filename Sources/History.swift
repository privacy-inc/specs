import Foundation
import Archivable

public struct History: Storable, Identifiable {
    public let id: Int
    public let website: Website
    
    public var data: Data {
        .init()
        .adding(UInt16(id))
        .adding(website)
    }
    
    public init(data: inout Data) {
        self.init(id: .init(data.number() as UInt16), website: .init(data: &data))
    }
    
    init(id: Int, website: Website) {
        self.id = id
        self.website = website
    }
}
