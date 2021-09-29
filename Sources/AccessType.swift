import Foundation
import Archivable

public protocol AccessType: Storable {
    var key: Access { get }
    var value: String { get }
    var content: Data { get }
}

extension AccessType {
    public var url: URL? {
        .init(string: value)
    }
    
    public init(data: inout Data) {
        fatalError()
    }
    
    public var data: Data {
        .init()
            .adding(key.rawValue)
            .adding(content)
    }
    
    public var content: Data {
        .init()
        .adding(UInt16.self, string: value)
    }
}
