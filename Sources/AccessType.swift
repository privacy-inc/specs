import Foundation
import Archivable

#warning("sunset")

protocol AccessType: Storable {
    var key: Access { get }
    var value: String { get }
    var content: Data { get }
    var icon: String? { get }
}

extension AccessType {
    var icon: String? {
        nil
    }
    
    init(data: inout Data) {
        fatalError()
    }
    
    var data: Data {
        .init()
            .adding(key.rawValue)
            .adding(content)
    }
}
