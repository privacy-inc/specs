import Foundation
import Archivable

extension Events.Relations {
    public struct Tracker: Storable {
        let timestamp: UInt16
        let tracker: UInt16
        
        public var data: Data {
            .init()
            .adding(timestamp)
            .adding(tracker)
        }
        
        public init(data: inout Data) {
            timestamp = data.number()
            tracker = data.number()
        }
        
        init(timestamp: Int, tracker: Int) {
            self.timestamp = .init(timestamp)
            self.tracker = .init(tracker)
        }
    }
}
