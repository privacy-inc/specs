import Foundation
import Archivable

extension Events {
    public struct Relations: Storable {
        public let items: [Item]
        public let trackers: [Tracker]
        
        public var data: Data {
            .init()
            .adding(size: UInt16.self, collection: items)
            .adding(size: UInt16.self, collection: trackers)
        }
        
        public init(data: inout Data) {
            items = data.collection(size: UInt16.self)
            trackers = data.collection(size: UInt16.self)
        }
        
        init() {
            self.init(items: [], trackers: [])
        }
        
        private init(items: [Item], trackers: [Tracker]) {
            self.items = items
            self.trackers = trackers
        }
        
        func width(item: Item) -> Self {
            .init(items: items + item, trackers: trackers)
        }
        
        func with(items: [Item]) -> Self {
            .init(items: items, trackers: trackers)
        }
        
        func with(trackers: [Tracker]) -> Self {
            .init(items: items, trackers: trackers)
        }
    }
}
