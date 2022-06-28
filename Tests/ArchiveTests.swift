import XCTest
@testable import Archivable
@testable import Specs

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testDifferentVersion() async {
        XCTAssertTrue(archive.history.isEmpty)
        archive.history = [.init(id: "https://avocado.org", title: "avoca")]
        archive = await Archive(version: 0, timestamp: archive.timestamp, data: archive.data)
        XCTAssertTrue(archive.history.isEmpty)
    }
    
    func testHistory() async {
        XCTAssertTrue(archive.history.isEmpty)
        archive.history = [.init(id: "https://avocado.org", title: "avoca")]
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertEqual("https://avocado.org", archive.history.first?.id)
        XCTAssertEqual("avoca", archive.history.first?.title)
    }
    
    func testBookmarks() async {
        XCTAssertTrue(archive.history.isEmpty)
        archive.bookmarks = [.init(id: "https://avocado.org", title: "avoca")]
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertEqual("https://avocado.org", archive.bookmarks.first?.id)
        XCTAssertEqual("avoca", archive.bookmarks.first?.title)
    }
    
    func testSettings() async {
        XCTAssertEqual(.google, archive.settings.search)
        archive.settings.search = .ecosia
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertEqual(.ecosia, archive.settings.search)
    }
}
