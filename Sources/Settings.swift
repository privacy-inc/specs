import Foundation
import Archivable

public struct Settings: Storable {
    public let search: Search
    public let configuration: Configuration
    public let policy: PolicyLevel
    
    public var data: Data {
        .init()
        .adding(search.engine.rawValue)
        .adding(policy.level.rawValue)
        .adding(configuration)
    }
    
    public init(data: inout Data) {
        search = .init(engine: .init(rawValue: data.removeFirst())!)
        policy = Policy.with(data: &data)
        configuration = .init(data: &data)
    }
    
    init() {
        search = .init(engine: .google)
        policy = Policy.Secure()
        configuration = .init()
    }
    
    private init(search: Search, policy: PolicyLevel, configuration: Configuration) {
        self.search = search
        self.policy = policy
        self.configuration = configuration
    }
    
    func with(search: Search) -> Self {
        .init(search: search, policy: policy, configuration: configuration)
    }
    
    func with(policy: PolicyLevel) -> Self {
        .init(search: search, policy: policy, configuration: configuration)
    }
    
    func with(configuration: Configuration) -> Self {
        .init(search: search, policy: policy, configuration: configuration)
    }
}
