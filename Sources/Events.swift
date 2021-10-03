import Foundation
import Archivable

public struct Events: Storable {
    public let domains: [String]
    public let trackers: [String]
    public let timestamps: [UInt32]
    public let relations: Relations
    
    public var data: Data {
        .init()
        .adding(collection: UInt16.self, strings: UInt8.self, items: domains)
        .adding(collection: UInt16.self, strings: UInt8.self, items: trackers)
        .adding(size: UInt16.self, collection: timestamps)
        .adding(relations)
    }
    
    public init(data: inout Data) {
        domains = data.items(collection: UInt16.self, strings: UInt8.self)
        trackers = data.items(collection: UInt16.self, strings: UInt8.self)
        timestamps = data.collection(size: UInt16.self)
        relations = .init(data: &data)
    }
    
    init() {
        self.init(domains: [], trackers: [], timestamps: [], relations: .init())
    }
    
    private init(domains: [String], trackers: [String], timestamps: [UInt32], relations: Relations) {
        self.domains = domains
        self.trackers = trackers
        self.timestamps = timestamps
        self.relations = relations
    }
    
    func with(domains: [String]) -> Self {
        .init(domains: domains, trackers: trackers, timestamps: timestamps, relations: relations)
    }
    
    func with(trackers: [String]) -> Self {
        .init(domains: domains, trackers: trackers, timestamps: timestamps, relations: relations)
    }
    
    func with(timestamps: [UInt32]) -> Self {
        .init(domains: domains, trackers: trackers, timestamps: timestamps, relations: relations)
    }
    
    func with(relations: Relations) -> Self {
        .init(domains: domains, trackers: trackers, timestamps: timestamps, relations: relations)
    }
}
