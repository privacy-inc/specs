import XCTest
@testable import Archivable
@testable import Specs

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testHistory() async {
        XCTAssertTrue(archive.history.isEmpty)
        archive.history = [.init(id: "https://avocado.org", title: "avoca")]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual("https://avocado.org", archive.history.first?.id)
        XCTAssertEqual("avoca", archive.history.first?.title)
    }
    
    func testBookmarks() async {
        XCTAssertTrue(archive.history.isEmpty)
        archive.bookmarks = [.init(id: "https://avocado.org", title: "avoca")]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual("https://avocado.org", archive.bookmarks.first?.id)
        XCTAssertEqual("avoca", archive.bookmarks.first?.title)
    }
    
    func testSettings() async {
        XCTAssertEqual(.google, archive.settings.search.engine)
        archive.settings = archive.settings
            .with(search: .init(engine: .ecosia))
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(.ecosia, archive.settings.search.engine)
    }
}
