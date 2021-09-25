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
}
