import XCTest
@testable import Specs

final class EventsTests: XCTestCase {
    func testStorable() {
        let events = Events()
            .with(domains: ["hello", "world"])
            .with(trackers: ["lorem"])
            .with(timestamps: [5, 6])
            .with(items: [.init(timestamp: 45, domain: 56), .init(timestamp: 5, domain: 5)])
            .with(blocked: [.init(relation: 451, tracker: 543), .init(relation: 99, tracker: 0)])
        let parsed = events.data.prototype(Events.self)
        XCTAssertEqual(["hello", "world"], parsed.domains)
        XCTAssertEqual(["lorem"], parsed.trackers)
        XCTAssertEqual([5, 6], parsed.timestamps)
        XCTAssertEqual(2, parsed.items.count)
        XCTAssertEqual(45, parsed.items.first?.timestamp)
        XCTAssertEqual(56, parsed.items.first?.domain)
        XCTAssertEqual(2, parsed.blocked.count)
        XCTAssertEqual(451, parsed.blocked.first?.relation)
        XCTAssertEqual(543, parsed.blocked.first?.tracker)
    }
    
    func testAdd() {
        let now = UInt32.now
        let events = Events()
            .add(domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertGreaterThanOrEqual(events.timestamps.first!, now)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual("avocado.org", events.domains.first)
        XCTAssertEqual(1, events.items.count)
        XCTAssertTrue(events.blocked.isEmpty)
        XCTAssertEqual(0, events.items.first?.timestamp)
        XCTAssertEqual(0, events.items.first?.domain)
    }
    
    func testDontDuplicateDomain() {
        let events = Events()
            .add(domain: "avocado.org")
            .add(domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual(1, events.items.count)
    }
    
    func testTimestampsPerMinute() {
        let now = UInt32.now
        XCTAssertEqual(1, Events()
                        .with(timestamps: [now - 59])
                        .add(domain: "avocado.org")
                        .timestamps.count)
        XCTAssertEqual(2, Events()
                        .with(timestamps: [now - 61])
                        .add(domain: "avocado.org")
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
        XCTAssertEqual(1, events.items.count)
        XCTAssertEqual(1, events.blocked.count)
        XCTAssertEqual(0, events.items.first?.timestamp)
        XCTAssertEqual(0, events.items.first?.domain)
        XCTAssertEqual(0, events.blocked.first?.relation)
        XCTAssertEqual(0, events.blocked.first?.tracker)
    }
    
    func testDuplicateTracker() {
        let events = Events()
            .block(tracker: "google.com", domain: "avocado.org")
            .block(tracker: "google.com", domain: "lorem.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(2, events.domains.count)
        XCTAssertEqual(1, events.trackers.count)
        XCTAssertEqual(2, events.items.count)
        XCTAssertEqual(2, events.blocked.count)
    }
    
    func testShareRelation() {
        let events = Events()
            .block(tracker: "google.com", domain: "avocado.org")
            .block(tracker: "some.com", domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual(2, events.trackers.count)
        XCTAssertEqual(1, events.items.count)
        XCTAssertEqual(2, events.blocked.count)
    }
}
