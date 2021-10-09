import Foundation
import Domains

extension Policy {
    struct Validation {
        static let allow = Self(result: .allow, event: .none)
        static let ignore = Self(result: .ignore, event: .none)
        static let external = Self(result: .external, event: .none)
        
        static func allow(domain: Domain) -> Self {
            .init(result: .allow, event: .allow(domain))
        }
        
        static func block(tracker: String) -> Self {
            .init(result: .block, event: .block(tracker))
        }
        
        let result: Result
        let event: Event
        
        private init(result: Result, event: Event) {
            self.result = result
            self.event = event
        }
    }
}
