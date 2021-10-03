import XCTest
@testable import Specs

final class EventsTests: XCTestCase {
    func testStorable() {
        let events = Events()
            .with(domains: ["hello", "world"])
            .with(trackers: ["lorem"])
            .with(timestamps: [5, 6])
            .with(relations: .init()
                    .with(items: [.init(timestamp: 45, domain: 56), .init(timestamp: 5, domain: 5)])
                    .with(trackers: [.init(relation: 451, tracker: 543), .init(relation: 99, tracker: 0)]))
        let parsed = events.data.prototype(Events.self)
        XCTAssertEqual(["hello", "world"], parsed.domains)
        XCTAssertEqual(["lorem"], parsed.trackers)
        XCTAssertEqual([5, 6], parsed.timestamps)
        XCTAssertEqual(2, parsed.relations.items.count)
        XCTAssertEqual(45, parsed.relations.items.first?.timestamp)
        XCTAssertEqual(56, parsed.relations.items.first?.domain)
        XCTAssertEqual(2, parsed.relations.trackers.count)
        XCTAssertEqual(451, parsed.relations.trackers.first?.relation)
        XCTAssertEqual(543, parsed.relations.trackers.first?.tracker)
    }
    
    func testAllow() {
        let now = UInt32.now
        let events = Events()
            .allow(domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertGreaterThanOrEqual(events.timestamps.first!, now)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual("avocado.org", events.domains.first)
        XCTAssertEqual(1, events.relations.items.count)
        XCTAssertTrue(events.relations.trackers.isEmpty)
        XCTAssertEqual(0, events.relations.items.first?.timestamp)
        XCTAssertEqual(0, events.relations.items.first?.domain)
    }
    
    func testDuplicateDomain() {
        let events = Events()
            .allow(domain: "avocado.org")
            .allow(domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual(2, events.relations.items.count)
    }
    
    func testTimestampsPerMinute() {
        let now = UInt32.now
        XCTAssertEqual(1, Events()
                        .with(timestamps: [now - 59])
                        .allow(domain: "avocado.org")
                        .timestamps.count)
        XCTAssertEqual(2, Events()
                        .with(timestamps: [now - 61])
                        .allow(domain: "avocado.org")
                        .timestamps.count)
    }
    
    func testBlock() {
        let now = UInt32.now
        let events = Events()
            .block(tracker: "google.com", domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertGreaterThanOrEqual(events.timestamps.first!, now)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual("avocado.org", events.domains.first)
        XCTAssertEqual(1, events.trackers.count)
        XCTAssertEqual("google.com", events.trackers.first)
        XCTAssertEqual(1, events.relations.items.count)
        XCTAssertEqual(1, events.relations.trackers.count)
        XCTAssertEqual(0, events.relations.items.first?.timestamp)
        XCTAssertEqual(0, events.relations.items.first?.domain)
        XCTAssertEqual(0, events.relations.trackers.first?.relation)
        XCTAssertEqual(0, events.relations.trackers.first?.tracker)
    }
    
    func testDuplicateTracker() {
        let events = Events()
            .block(tracker: "google.com", domain: "avocado.org")
            .block(tracker: "google.com", domain: "lorem.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(2, events.domains.count)
        XCTAssertEqual(1, events.trackers.count)
        XCTAssertEqual(2, events.relations.items.count)
        XCTAssertEqual(2, events.relations.trackers.count)
    }
    
    func testShareRelation() {
        let events = Events()
            .block(tracker: "google.com", domain: "avocado.org")
            .block(tracker: "some.com", domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual(2, events.trackers.count)
        XCTAssertEqual(1, events.relations.items.count)
        XCTAssertEqual(2, events.relations.trackers.count)
    }
}
