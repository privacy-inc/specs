import XCTest
@testable import Archivable
@testable import Specs

final class MigrationTests: XCTestCase {
    private var archive: Archive_v0!
    
    override func setUp() {
        archive = .init()
    }
    
    func testMigrate() async {
        archive.history = [
            .init(id: 34, website: .init(url: URL(string: "https://avocado.org")!).with(title: "lorem ipsum")),
            .init(id: 38, website: .init(access: Access.Other(key: .deeplink, value: "dffsdf"))),
            .init(id: 36, website: .init(access: Access.Local(value: "some/local/file", bookmark: .init()))),
            .init(id: 1, website: .init(url: URL(string: "https://ttt.com")!))]
        
        archive.bookmarks += [.init(url: URL(string: "https://fsfsdfsd.com")!).with(title: "hello world")]
        archive.index = 99
        archive.settings = archive.settings.with(search: .ecosia)
        archive.settings = archive.settings.with(policy: .standard)
        
        archive.events = archive.events.add(domain: "avocado.org")
        archive.events = archive.events.block(tracker: "evil", domain: "something.com")
        archive.events = archive.events.block(tracker: "evil2", domain: "something.com")
        archive.events = archive.events.block(tracker: "evil3", domain: "hello.com")
        
        let migrated = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(2, migrated.history.count)
        XCTAssertEqual("https://avocado.org", migrated.history.first?.id)
        XCTAssertEqual("lorem ipsum", migrated.history.first?.title)
        XCTAssertEqual("https://ttt.com", migrated.history.last?.id)
        XCTAssertEqual(1, migrated.bookmarks.count)
        XCTAssertEqual("https://fsfsdfsd.com", migrated.bookmarks.first?.id)
        XCTAssertEqual("hello world", migrated.bookmarks.first?.title)
        XCTAssertEqual(.ecosia, migrated.settings.search)
        XCTAssertEqual(.standard, migrated.settings.policy)
    }
}
