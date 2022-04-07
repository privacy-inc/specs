import Foundation
import Domains
import Archivable

public struct Website: Storable, Identifiable {
    public let id: String
    public let title: String
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, string: id)
        .adding(size: UInt16.self, string: title)
    }
    
    public init(data: inout Data) {
        id = data.string(size: UInt16.self)
        title = data.string(size: UInt16.self)
    }
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    func with(id: String) -> Self {
        .init(id: id, title: title)
    }
    
    func with(title: String) -> Self {
        .init(id: id, title: title)
    }
    
    func filter(websites: [Self]) -> [Self] {
        let comparable = id.comparable
        return websites
            .filter {
                $0.id.comparable != comparable
            }
    }
}
