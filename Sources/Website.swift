import Foundation
import Archivable

public struct Website: Storable, Identifiable {
    public var id: String {
        access.value
    }
    
    public let title: String
    public let access: AccessType
    
    public var data: Data {
        .init()
        .adding(UInt16.self, string: title)
        .adding(access.data)
    }
    
    public init(data: inout Data) {
        title = data.string(UInt16.self)
        access = Access.with(data: &data)
    }
    
    init(access: AccessType) {
        self.init(title: "", access: access)
    }
    
    init(search: String) {
        self.init(title: "", access: Access.Remote(value: search))
    }
    
    private init(title: String, access: AccessType) {
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
