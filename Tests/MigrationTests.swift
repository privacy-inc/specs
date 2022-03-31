import XCTest
@testable import Archivable
@testable import Specs

final class MigrationTests: XCTestCase {
    private var archive: Archive_v0!
    
    override func setUp() {
        archive = .init()
    }
    
    func testMigrate() async {
        archive.events.add(domain: "avocado.org")
        archive.events.block(tracker: "evil", domain: "something.com")
        archive.events.block(tracker: "evil2", domain: "something.com")
        archive.events.block(tracker: "evil3", domain: "hello.com")
        let migrated = await Archive.prototype(data: archive.compressed)

    }
}
