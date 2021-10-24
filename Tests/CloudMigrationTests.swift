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
    
    func testBookmarks() async {
        await migrate()
        let model = await cloud.model
        
        XCTAssertEqual(14, model.bookmarks.count)
        XCTAssertEqual("Weather Berlin - Google Search", model.bookmarks.first?.title)
        XCTAssertEqual("https://www.google.com?q=weather+berlin", model.bookmarks.first?.access.value)
        XCTAssertEqual("Explained", model.bookmarks.last?.title)
        XCTAssertEqual("https://thelocal", model.bookmarks.last?.access.value)
    }
    
    private func migrate() async {
        let data = try! Data(contentsOf: Bundle.module.url(forResource: "Privacy", withExtension: "archive")!)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Privacy.archive")
        try! data.write(to: url)
        await cloud.migrate(url: url)
    }
}
