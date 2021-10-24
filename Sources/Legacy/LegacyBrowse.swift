import Foundation
import Archivable

public struct LegacyBrowse: Storable {
    public let page: LegacyPage
    
    public var data: Data {
        fatalError()
    }
    
    public init(data: inout Data) {
        _ = data.number() as UInt16
        _ = data.date()
        page = .init(data: &data)
    }
}
