import Foundation
import Archivable

public struct Settings: Storable {
    public internal(set) var search: Search
    public internal(set) var policy: PolicyLevel
    
    public var data: Data {
        .init()
        .adding(search.engine.rawValue)
        .adding(policy.level.rawValue)
    }
    
    public init(data: inout Data) {
        search = .init(engine: .init(rawValue: data.removeFirst())!)
        policy = Policy.with(data: &data)
    }
    
    init() {
        search = .init(engine: .google)
        policy = Policy.Secure()
    }
}
