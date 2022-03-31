import XCTest
@testable import Archivable
@testable import Specs

final class MigrationTests: XCTestCase {
    private var archive: Archive_v0!
    
    override func setUp() {
        archive = .init()
    }
    
    func testMigrate() async {
        archive.history = archive.history.adding(.init(id: 34, website: .init(url: URL(string: "https://avocado.org")!)))
        archive.bookmarks += [archive.history.first!.website]
        archive.index = 99
        archive.settings = archive.settings.with(search: .init(engine: .ecosia))
        
        archive.events.add(domain: "avocado.org")
        archive.events.block(tracker: "evil", domain: "something.com")
        archive.events.block(tracker: "evil2", domain: "something.com")
        archive.events.block(tracker: "evil3", domain: "hello.com")
        
        let migrated = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(99, migrated.index)
        XCTAssertEqual(1, migrated.history.count)
        XCTAssertEqual("https://avocado.org", migrated.history.first?.website.id)
        XCTAssertEqual(34, migrated.history.first?.id)
        XCTAssertEqual(1, migrated.bookmarks.count)
        XCTAssertEqual("https://avocado.org", migrated.bookmarks.first?.id)
        XCTAssertEqual(.ecosia, migrated.settings.search.engine)
    }
}
