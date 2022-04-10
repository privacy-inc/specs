import Foundation
import Archivable

#warning("sunset")

struct Settings_v0: Storable {
    var search: Search
    var configuration: Configuration_v0
    var policy: Policy
    
    var data: Data {
        .init()
        .adding(search.rawValue)
        .adding(policy.rawValue)
        .adding(configuration)
    }
    
    init(data: inout Data) {
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
