import Foundation
import Archivable

public struct Events: Storable {
    public let allowed: [Allowed]
    public let blocked: [Blocked]
    public let domains: [String]
    public let trackers: [String]
    public let timestamps: [UInt32]
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, collection: allowed)
        .adding(size: UInt16.self, collection: blocked)
        .adding(collection: UInt16.self, strings: UInt8.self, items: domains)
        .adding(collection: UInt16.self, strings: UInt8.self, items: trackers)
        .adding(size: UInt16.self, collection: timestamps)
    }
    
    public init(data: inout Data) {
        allowed = data.collection(size: UInt16.self)
        blocked = data.collection(size: UInt16.self)
        domains = data.items(collection: UInt16.self, strings: UInt8.self)
        trackers = data.items(collection: UInt16.self, strings: UInt8.self)
        timestamps = data.collection(size: UInt16.self)
    }
    
    init() {
        self.init(allowed: [], blocked: [], domains: [], trackers: [], timestamps: [])
    }
    
    private init(allowed: [Allowed], blocked: [Blocked], domains: [String], trackers: [String], timestamps: [UInt32]) {
        self.allowed = allowed
        self.blocked = blocked
        self.domains = domains
        self.trackers = trackers
        self.timestamps = timestamps
    }
    
    func allow(domain: String) -> Self {
        timestamps
            .timestamp { timestamp, timestamps in
                domains
                    .index(element: domain) { domain, domains in
                    .init(
                        allowed: allowed + .init(timestamp: timestamp, domain: domain),
                        blocked: blocked,
                        domains: domains,
                        trackers: trackers,
                        timestamps: timestamps)
                    }
            }
    }
    
    func block(tracker: String, domain: String) -> Self {
        timestamps
            .timestamp { timestamp, timestamps in
                domains
                    .index(element: domain) { domain, domains in
                        trackers
                            .index(element: tracker) { tracker, trackers in
                                allowed
                                    .index(element: .init(timestamp: timestamp, domain: domain)) { allow, allowed in
                                    .init(
                                        allowed: allowed,
                                        blocked: blocked + .init(relation: allow, tracker: tracker),
                                        domains: domains,
                                        trackers: trackers,
                                        timestamps: timestamps)
                                    }
                            }
                    }
            }
    }
    
    func with(allowed: [Allowed]) -> Self {
        .init(allowed: allowed, blocked: blocked, domains: domains, trackers: trackers, timestamps: timestamps)
    }
    
    func with(blocked: [Blocked]) -> Self {
        .init(allowed: allowed, blocked: blocked, domains: domains, trackers: trackers, timestamps: timestamps)
    }
    
    func with(domains: [String]) -> Self {
        .init(allowed: allowed, blocked: blocked, domains: domains, trackers: trackers, timestamps: timestamps)
    }
    
    func with(trackers: [String]) -> Self {
        .init(allowed: allowed, blocked: blocked, domains: domains, trackers: trackers, timestamps: timestamps)
    }
    
    func with(timestamps: [UInt32]) -> Self {
        .init(allowed: allowed, blocked: blocked, domains: domains, trackers: trackers, timestamps: timestamps)
    }
}
