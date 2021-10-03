import XCTest
@testable import Specs

final class EventsTests: XCTestCase {
    func testStorable() {
        let events = Events()
            .with(domains: ["hello", "world"])
            .with(trackers: ["lorem"])
            .with(timestamps: [5, 6])
            .with(relations: .init()
                    .with(domains: [.init(timestamp: 45, domain: 56), .init(timestamp: 5, domain: 5)])
                    .with(trackers: [.init(timestamp: 451, tracker: 543), .init(timestamp: 99, tracker: 0)]))
        let parsed = events.data.prototype(Events.self)
        XCTAssertEqual(["hello", "world"], parsed.domains)
        XCTAssertEqual(["lorem"], parsed.trackers)
        XCTAssertEqual([5, 6], parsed.timestamps)
        XCTAssertEqual(2, parsed.relations.domains.count)
        XCTAssertEqual(45, parsed.relations.domains.first?.timestamp)
        XCTAssertEqual(56, parsed.relations.domains.first?.domain)
        XCTAssertEqual(2, parsed.relations.trackers.count)
        XCTAssertEqual(451, parsed.relations.trackers.first?.timestamp)
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
        XCTAssertEqual(1, events.relations.domains.count)
        XCTAssertTrue(events.relations.trackers.isEmpty)
        XCTAssertEqual(0, events.relations.domains.first?.timestamp)
        XCTAssertEqual(0, events.relations.domains.first?.domain)
    }
    
    /*
     let now = Date()
     let last = $0.activity.last ?? .distantPast
     if last < Calendar.current.date(byAdding: .minute, value: -1, to: now)! {
         $0.activity.append(now)
     }
     */
}
