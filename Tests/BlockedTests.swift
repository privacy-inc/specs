import XCTest
@testable import Specs

final class BlockedTests: XCTestCase {
    func testStorable() {
        let blocked = Blocked()
            .with(domains: ["hello", "world"])
            .with(trackers: ["lorem"])
            .with(events: [.init(domain: 3, tracker: 5), .init(domain: 7, tracker: 6), .init(domain: 0, tracker: 0)])
        let parsed = blocked.data.prototype(Blocked.self)
        XCTAssertEqual(["hello", "world"], parsed.domains)
        XCTAssertEqual(["lorem"], parsed.trackers)
        XCTAssertEqual(3, parsed.events.count)
    }
    
    func testEvents() {
        let date = Date().timestamp
        let event = Blocked.Event(domain: 99, tracker: 34)
        let parsed = event.data.prototype(Blocked.Event.self)
        XCTAssertGreaterThanOrEqual(parsed.timestamp, date)
        XCTAssertEqual(99, parsed.domain)
        XCTAssertEqual(34, parsed.tracker)
    }
}
