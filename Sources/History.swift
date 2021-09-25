import Foundation
import Archivable

public struct History: Storable {
    public let id: Int
    public let website: Website
    
    public var data: Data {
        .init()
        .adding(UInt16(id))
        .adding(website.data)
    }
    
    public init(data: inout Data) {
        self.init(id: .init(data.uInt16()), website: .init(data: &data))
    }
    
    init(id: Int, website: Website) {
        self.id = id
        self.website = website
    }
}
