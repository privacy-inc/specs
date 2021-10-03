import XCTest
@testable import Specs

final class EventsTests: XCTestCase {
    func testStorable() {
        let blocked = Events()
            .with(domains: ["hello", "world"])
            .with(trackers: ["lorem"])
            .with(timestamps: [5, 6])
            .with(relations: .init()
                    .with(domains: [.init(timestamp: 45, domain: 56), .init(timestamp: 5, domain: 5)])
                    .with(trackers: [.init(timestamp: 451, tracker: 543), .init(timestamp: 99, tracker: 0)]))
        let parsed = blocked.data.prototype(Events.self)
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
}
