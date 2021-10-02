import Foundation
import Archivable

extension Blocked {
    struct Event: Storable {
        let timestamp: UInt32
        let domain: UInt16
        let tracker: UInt16
        
        var data: Data {
            .init()
            .adding(timestamp)
            .adding(domain)
            .adding(tracker)
        }
        
        init(domain: Int, tracker: Int) {
            timestamp = .now
            self.domain = .init(domain)
            self.tracker = .init(tracker)
        }
        
        init(data: inout Data) {
            timestamp = data.number()
            domain = data.number()
            tracker = data.number()
        }
    }
}
