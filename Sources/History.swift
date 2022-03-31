import Foundation
import Archivable

#warning("sunset")

struct History: Storable, Identifiable {
    let id: UInt16
    let website: Website_v0
    
    var data: Data {
        .init()
        .adding(id)
        .adding(website)
    }
    
    init(data: inout Data) {
        self.init(id: data.number(), website: .init(data: &data))
    }
    
    init(id: UInt16, website: Website_v0) {
        self.id = id
        self.website = website
    }
}
