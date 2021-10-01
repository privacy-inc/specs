import Foundation
import Archivable

public protocol AccessType: Storable {
    var key: Access { get }
    var value: String { get }
    var content: Data { get }
}

extension AccessType {
    public init(data: inout Data) {
        fatalError()
    }
    
    public var data: Data {
        .init()
            .adding(key.rawValue)
            .adding(content)
    }
}
