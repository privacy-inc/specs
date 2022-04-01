import Foundation
import Archivable

#warning("sunset")

struct Events: Storable {
    let items: [Item]
    let domains: [String]
    let trackers: [String]
    let timestamps: [UInt32]
    
    var prevented: Int {
        items
            .map(\.trackers.count)
            .reduce(0, +)
    }
    
    var since: Date? {
        timestamps
            .first
            .map(Date.init(timestamp:))
    }
    
    var data: Data {
        .init()
        .adding(size: UInt16.self, collection: items)
        .adding(collection: UInt16.self, strings: UInt8.self, items: domains)
        .adding(collection: UInt16.self, strings: UInt8.self, items: trackers)
        .adding(size: UInt16.self, collection: timestamps)
    }
    
    init(data: inout Data) {
        items = data.collection(size: UInt16.self)
        domains = data.items(collection: UInt16.self, strings: UInt8.self)
        trackers = data.items(collection: UInt16.self, strings: UInt8.self)
        timestamps = data.collection(size: UInt16.self)
    }
    
    init() {
        self.init(items: [], domains: [], trackers: [], timestamps: [])
    }
    
    private init(items: [Item], domains: [String], trackers: [String], timestamps: [UInt32]) {
        self.items = items
        self.domains = domains
        self.trackers = trackers
        self.timestamps = timestamps
    }
    
    func with(items: [Item]) -> Self {
        .init(items: items, domains: domains, trackers: trackers, timestamps: timestamps)
    }
    
    func with(domains: [String]) -> Self {
        .init(items: items, domains: domains, trackers: trackers, timestamps: timestamps)
    }
    
    func with(trackers: [String]) -> Self {
        .init(items: items, domains: domains, trackers: trackers, timestamps: timestamps)
    }
    
    func with(timestamps: [UInt32]) -> Self {
        .init(items: items, domains: domains, trackers: trackers, timestamps: timestamps)
    }
}
