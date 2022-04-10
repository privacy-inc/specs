import Foundation
import Archivable

public struct Settings: Storable {
    public internal(set) var search: Search
    public internal(set) var configuration: Configuration
    public internal(set) var policy: Policy
    
    public var data: Data {
        .init()
        .adding(search.rawValue)
        .adding(policy.rawValue)
        .adding(configuration)
    }
    
    public init(data: inout Data) {
        search = .init(rawValue: data.removeFirst())!
        policy = .init(rawValue: data.removeFirst())!
        configuration = .init(data: &data)
    }
    
    init() {
        search = .google
        policy = .secure
        configuration = .init()
    }
}
