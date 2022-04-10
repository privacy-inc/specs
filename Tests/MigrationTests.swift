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
        
        archive.events = .init()
            .with(domains: ["avocado.org"])
            .with(trackers: ["evil1.org", "evil2.org"])
            .with(timestamps: [1, 2, 3])
            .with(items: [.init(timestamp: 3, domain: 1)])
        
        archive.bookmarks += [.init(url: URL(string: "https://fsfsdfsd.com")!).with(title: "hello world")]
        archive.index = 99
        archive.settings.search = .ecosia
        archive.settings.policy = .standard
        archive.settings.configuration.autoplay = .all
        archive.settings.configuration.javascript = false
        archive.settings.configuration.popups = true
        archive.settings.configuration.location = true
        archive.settings.configuration.timers = false
        archive.settings.configuration.dark = false
        archive.settings.configuration.ads = true
        archive.settings.configuration.screen = true
        archive.settings.configuration.cookies = true
        archive.settings.configuration.http = true
        archive.settings.configuration.third = false
        
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
        XCTAssertEqual(.all, migrated.settings.configuration.autoplay)
        XCTAssertFalse(migrated.settings.configuration.javascript)
        XCTAssertTrue(migrated.settings.configuration.popups)
        XCTAssertTrue(migrated.settings.configuration.location)
        XCTAssertFalse(migrated.settings.configuration.timers)
        XCTAssertFalse(migrated.settings.configuration.dark)
        XCTAssertTrue(migrated.settings.configuration.ads)
        XCTAssertTrue(migrated.settings.configuration.screen)
        XCTAssertTrue(migrated.settings.configuration.cookies)
        XCTAssertTrue(migrated.settings.configuration.http)
        XCTAssertFalse(migrated.settings.configuration.third)
    }
}
