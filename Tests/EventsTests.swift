import XCTest
@testable import Specs

final class EventsTests: XCTestCase {
    func testStorable() {
        let events = Events()
            .with(domains: ["hello", "world"])
            .with(trackers: ["lorem"])
            .with(timestamps: [5, 6])
            .with(items: [.init(timestamp: 45, domain: 56)
                            .with(tracker: 543)
                            .with(tracker: 321),
                          .init(timestamp: 5, domain: 5)
                            .with(tracker: 0)])
        let parsed = events.data.prototype(Events.self)
        XCTAssertEqual(["hello", "world"], parsed.domains)
        XCTAssertEqual(["lorem"], parsed.trackers)
        XCTAssertEqual([5, 6], parsed.timestamps)
        XCTAssertEqual(2, parsed.items.count)
        XCTAssertEqual(45, parsed.items.first?.timestamp)
        XCTAssertEqual(56, parsed.items.first?.domain)
        XCTAssertEqual(2, parsed.items.first?.trackers.count)
        XCTAssertTrue(parsed.items.first?.trackers.contains(543) ?? false)
        XCTAssertTrue(parsed.items.first?.trackers.contains(321) ?? false)
        XCTAssertEqual(0, parsed.items.last?.trackers.first)
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
        XCTAssertTrue(events.items.first?.trackers.isEmpty ?? false)
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
    
    func testTimestampsPer10Minutes() {
        let now = UInt32.now
        XCTAssertEqual(1, Events()
                        .with(timestamps: [now - 59])
                        .add(domain: "avocado.org")
                        .timestamps.count)
        XCTAssertEqual(1, Events()
                        .with(timestamps: [now - 61])
                        .add(domain: "avocado.org")
                        .timestamps.count)
        XCTAssertEqual(2, Events()
                        .with(timestamps: [now - 601])
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
        XCTAssertEqual(1, events.items.first?.trackers.count)
        XCTAssertEqual(0, events.items.first?.timestamp)
        XCTAssertEqual(0, events.items.first?.domain)
        XCTAssertEqual(0, events.items.first?.trackers.first)
    }
    
    func testDuplicateTracker() {
        let events = Events()
            .block(tracker: "google.com", domain: "avocado.org")
            .block(tracker: "google.com", domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual(1, events.trackers.count)
        XCTAssertEqual(1, events.items.count)
        XCTAssertEqual(1, events.items.first?.trackers.count)
    }
    
    func testDuplicateTrackerDifferentDomain() {
        let events = Events()
            .block(tracker: "google.com", domain: "avocado.org")
            .block(tracker: "google.com", domain: "lorem.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(2, events.domains.count)
        XCTAssertEqual(1, events.trackers.count)
        XCTAssertEqual(2, events.items.count)
        XCTAssertEqual(1, events.items.first?.trackers.count)
        XCTAssertEqual(1, events.items.last?.trackers.count)
    }
    
    func testShareRelation() {
        let events = Events()
            .block(tracker: "google.com", domain: "avocado.org")
            .block(tracker: "some.com", domain: "avocado.org")
        XCTAssertEqual(1, events.timestamps.count)
        XCTAssertEqual(1, events.domains.count)
        XCTAssertEqual(2, events.trackers.count)
        XCTAssertEqual(1, events.items.count)
        XCTAssertEqual(2, events.items.first?.trackers.count)
    }
    
    func testStatsTimelineEmpty() {
        XCTAssertEqual([], Events().stats.timeline)
    }
    
    func testStatsTimeline() {
        XCTAssertEqual([1, 1, 0, 0, 1, 1, 0, 0, 0, 0], Events()
                        .with(timestamps: [
                            Date(timeIntervalSinceNow: -60 * 60 * 24 * 6.9).timestamp,
                            Date(timeIntervalSinceNow: -60 * 60 * 24 * 6.1).timestamp,
                            Date(timeIntervalSinceNow: -60 * 60 * 24 * 4).timestamp,
                            Date(timeIntervalSinceNow: -60 * 60 * 24 * 3.2).timestamp])
                        .stats
                        .timeline)
    }
}
