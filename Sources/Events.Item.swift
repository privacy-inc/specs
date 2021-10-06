import Foundation
import Archivable

extension Events {
    struct Item: Storable {
        let timestamp: UInt16
        let domain: UInt16
        let trackers: Set<UInt16>
        
        var data: Data {
            .init()
            .adding(timestamp)
            .adding(domain)
            .adding(size: UInt8.self, collection: trackers)
        }
        
        init(data: inout Data) {
            timestamp = data.number()
            domain = data.number()
            trackers = .init(data.collection(size: UInt8.self))
        }
        
        init(timestamp: Int, domain: Int) {
            self.init(timestamp: .init(timestamp), domain: .init(domain), trackers: [])
        }
        
        private init(timestamp: UInt16, domain: UInt16, trackers: Set<UInt16>) {
            self.timestamp = .init(timestamp)
            self.domain = .init(domain)
            self.trackers = trackers
        }
        
        func with(tracker: Int) -> Self {
            .init(timestamp: timestamp, domain: domain, trackers: trackers
                    .inserting(.init(tracker)))
        }
    }
}
