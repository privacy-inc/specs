import Foundation
import Archivable

public struct Settings: Storable {
    public internal(set) var search: Search
    
    public var data: Data {
        .init()
        .adding(search.data)
    }
    
    public init(data: inout Data) {
        search = .init(data: &data)
    }
}
