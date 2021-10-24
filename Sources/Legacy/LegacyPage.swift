import Foundation
import Archivable

public struct LegacyPage: Storable {
    public let title: String
    public let access: String?
    
    public var data: Data {
        fatalError()
    }
    
    public init(data: inout Data) {
        title = data.string(size: UInt16.self)
        
        switch Access(rawValue: data.removeFirst())! {
        case .remote:
            access = data.string(size: UInt16.self)
        case .deeplink, .embed:
            _ = data.string(size: UInt16.self)
            access = nil
        case .local:
            _ = data.string(size: UInt16.self)
            _ = data.unwrap(size: UInt16.self)
            access = nil
        }
    }
}
