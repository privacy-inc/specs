import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudMigrationTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .ephemeral
        subs = []
    }
    
    func testInvalidURL() async {
        await cloud.migrate(url: URL(fileURLWithPath: "/some.txt"))
    }
    
    func testInvalidData() async {
        let data = Data("hello world".utf8)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Privacy.archive")
        try! data.write(to: url)
        await cloud.migrate(url: url)
    }
}
