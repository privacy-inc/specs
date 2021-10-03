import XCTest
@testable import Archivable
@testable import Specs

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testIndex() async {
        XCTAssertEqual(0, archive.index)
        archive.index = 100
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(100, archive.index)
    }
    
    func testHistory() async {
        XCTAssertTrue(archive.history.isEmpty)
        archive.history = [.init(id: 99, website: .init(access: Access.with(url: URL(string: "https://avocado.org")!)))]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual("https://avocado.org", archive.history.first?.website.access.value)
        XCTAssertEqual(99, archive.history.first?.id)
    }
    
    func testBookmarks() async {
        XCTAssertTrue(archive.history.isEmpty)
        archive.bookmarks = [.init(access: Access.with(url: URL(string: "https://avocado.org")!))]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual("https://avocado.org", archive.bookmarks.first?.access.value)
    }
    
    func testSettings() async {
        XCTAssertEqual(.google, archive.settings.search.engine)
        archive.settings.search = .init(engine: .ecosia)
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(.ecosia, archive.settings.search.engine)
    }
    
    func testCards() async {
        XCTAssertEqual(4, archive.cards.count)
        archive.cards.remove(at: 0)
        XCTAssertEqual(3, archive.cards.count)
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(3, archive.cards.count)
    }
    
    func testEvents() async {
        archive.events = archive
            .events
            .with(domains: ["hello", "world"])
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(["hello", "world"], archive.events.domains)
    }
}
