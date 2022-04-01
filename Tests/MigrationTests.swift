import XCTest
@testable import Archivable
@testable import Specs
/*
final class MigrationTests: XCTestCase {
    private var archive: Archive_v0!
    
    override func setUp() {
        archive = .init()
    }
    
    func testMigrate() async {
        archive.history = archive.history.adding(.init(id: 1, website: .init(url: URL(string: "https://ttt.com")!)))
        archive.history = archive.history.adding(.init(id: 36, website: .init(access: Access.Local(value: "some/local/file", bookmark: .init()))))
        archive.history = archive.history.adding(.init(id: 38, website: .init(access: Access.Other(key: .deeplink, value: "dffsdf"))))
        archive.history = archive.history.adding(.init(id: 34, website: .init(url: URL(string: "https://avocado.org")!)))
        
        archive.bookmarks += [archive.history.first!.website]
        archive.index = 99
        archive.settings = archive.settings.with(search: .init(engine: .ecosia))
        archive.settings = archive.settings.with(policy: .standard)
        
        archive.events = archive.events.add(domain: "avocado.org")
        archive.events = archive.events.block(tracker: "evil", domain: "something.com")
        archive.events = archive.events.block(tracker: "evil2", domain: "something.com")
        archive.events = archive.events.block(tracker: "evil3", domain: "hello.com")
        
        let migrated = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(2, migrated.history.count)
        XCTAssertEqual("https://avocado.org", migrated.history.first?.id)
        XCTAssertEqual("https://ttt.com", migrated.history.last?.id)
        XCTAssertEqual(1, migrated.bookmarks.count)
        XCTAssertEqual("https://avocado.org", migrated.bookmarks.first?.id)
        XCTAssertEqual(.ecosia, migrated.settings.search.engine)
        XCTAssertEqual(.standard, migrated.settings.policy)
    }
}
*/
