import Foundation
import Archivable

extension Events {
    public struct Relations: Storable {
        public let domains: [Domain]
        public let trackers: [Tracker]
        
        public var data: Data {
            .init()
            .adding(size: UInt16.self, collection: domains)
            .adding(size: UInt16.self, collection: trackers)
        }
        
        public init(data: inout Data) {
            domains = data.collection(size: UInt16.self)
            trackers = data.collection(size: UInt16.self)
        }
        
        init() {
            self.init(domains: [], trackers: [])
        }
        
        private init(domains: [Domain], trackers: [Tracker]) {
            self.domains = domains
            self.trackers = trackers
        }
        
        func width(domain: Domain) -> Self {
            .init(domains: domains + domain, trackers: trackers)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        func with(domains: [Domain]) -> Self {
            .init(domains: domains, trackers: trackers)
        }
        
        func with(trackers: [Tracker]) -> Self {
            .init(domains: domains, trackers: trackers)
        }
    }
}
