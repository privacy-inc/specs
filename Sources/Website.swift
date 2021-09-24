import Foundation
import Archivable

public struct Website: Storable {
    public let title: String
    public let access: AccessType
    
    public var data: Data {
        .init()
            .adding(title)
            .adding(access.data)
    }
    
    public init(data: inout Data) {
        title = data.string()
        access = Access.with(data: &data)
    }
    
    init(title: String = "", access: AccessType) {
        self.title = title
        self.access = access
    }
    
    func with(title: String) -> Self {
        .init(title: title, access: access)
    }
    
    func with(access: AccessType) -> Self {
        .init(title: title, access: access)
    }
}
