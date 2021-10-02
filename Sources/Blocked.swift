import Foundation
import Archivable

public struct Blocked: Storable {
    let domains: [String]
    let trackers: [String]
    let events: [Event]
    
    public var data: Data {
        .init()
        .adding(collection: UInt16.self, strings: UInt8.self, items: domains)
        .adding(collection: UInt16.self, strings: UInt8.self, items: trackers)
        .adding(size: UInt16.self, collection: events)
    }
    
    init() {
        domains = []
        trackers = []
        events = []
    }
    
    public init(data: inout Data) {
        domains = data.items(collection: UInt16.self, strings: UInt8.self)
        trackers = data.items(collection: UInt16.self, strings: UInt8.self)
        events = data.collection(size: UInt16.self)
    }
    
    private init(domains: [String], trackers: [String], events: [Event]) {
        self.domains = domains
        self.trackers = trackers
        self.events = events
    }
    
    func with(domains: [String]) -> Self {
        .init(domains: domains, trackers: trackers, events: events)
    }
    
    func with(trackers: [String]) -> Self {
        .init(domains: domains, trackers: trackers, events: events)
    }
    
    func with(events: [Event]) -> Self {
        .init(domains: domains, trackers: trackers, events: events)
    }
}
