import Foundation
import Archivable

public protocol AccessType: Storable {
    var key: Access { get }
    var value: String { get }
    var content: Data { get }
    var icon: String? { get }
}

extension AccessType {
    public var icon: String? {
        nil
    }
    
    public init(data: inout Data) {
        fatalError()
    }
    
    public var data: Data {
        .init()
            .adding(key.rawValue)
            .adding(content)
    }
}
