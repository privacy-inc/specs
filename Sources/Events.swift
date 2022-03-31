import Foundation
import Archivable

#warning("sunset")

public struct Events: Storable {
    let items: [Item]
    let domains: [String]
    let trackers: [String]
    let timestamps: [UInt32]
    
    public var prevented: Int {
        items
            .map(\.trackers.count)
            .reduce(0, +)
    }
    
    public var since: Date? {
        timestamps
            .first
            .map(Date.init(timestamp:))
    }
    
    public var report: [Report] {
        items
            .reversed()
            .reduce(into: []) {
                $0.append(.init(
                    date: .init(timestamp: timestamps[.init($1.timestamp)]),
                    website: domains[.init($1.domain)],
                    trackers: $1
                        .trackers
                        .map {
                            trackers[.init($0)]
                        }))
            }
    }
    
    public var stats: Stats {
        .init(timeline: timestamps.timeline,
              websites: items.count,
              domains: domains.isEmpty
              ? nil
              : (top: items
                    .map {
                        domains[.init($0.domain)]
                    }
                    .top, count: domains.count),
              trackers: trackers.isEmpty
              ? nil
              : (top: items
                    .flatMap(\.trackers)
                    .map {
                        trackers[.init($0)]
                    }
                    .top, count: trackers.count))
    }
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, collection: items)
        .adding(collection: UInt16.self, strings: UInt8.self, items: domains)
        .adding(collection: UInt16.self, strings: UInt8.self, items: trackers)
        .adding(size: UInt16.self, collection: timestamps)
    }
    
    public init(data: inout Data) {
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
    
    func add(domain: String) -> Self {
        add(domain: domain) { _, items, domains, timestamps in
            .init(
                items: items,
                domains: domains,
                trackers: trackers,
                timestamps: timestamps)
        }
    }
    
    func block(tracker: String, domain: String) -> Self {
        add(domain: domain) { item, items, domains, timestamps in
            trackers
                .index(element: tracker) { tracker, trackers in
                .init(
                    items: items
                        .mutating(index: item) {
                            $0
                                .with(tracker: tracker)
                        },
                    domains: domains,
                    trackers: trackers,
                    timestamps: timestamps)
                }
        }
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
    
    private func add(domain: String, transform: (Int, [Item], [String], [UInt32]) -> Self) -> Self {
        timestamps
            .timestamp { timestamp, timestamps in
                domains
                    .index(element: domain) { domain, domains in
                        items
                            .index(element: .init(timestamp: timestamp, domain: domain)) { item, items in
                                transform(item, items, domains, timestamps)
                            }
                    }
            }
    }
}
