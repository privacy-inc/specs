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
        .adding(size: UInt16.self, string: title)
        .adding(access.data)
    }
    
    public init(data: inout Data) {
        title = data.string(size: UInt16.self)
        access = Access.with(data: &data)
    }
    
    init(access: AccessType) {
        self.init(title: "", access: access)
    }
    
    init(url: URL) {
        self.init(title: "", access: Access.with(url: url))
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
