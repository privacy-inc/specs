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
    
    func testInvalidNotSaving() {
        let expect = expectation(description: "")
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            await cloud.migrate(url: URL(fileURLWithPath: "/some.txt"))
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testInvalidData() async {
        let data = Data("hello world".utf8)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Privacy.archive")
        try! data.write(to: url)
        await cloud.migrate(url: url)
    }
    
    func testSaves() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            await migrate()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testRemoves() async {
        let url = await migrate()
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testBookmarks() async {
        await migrate()
        let model = await cloud.model
        
        XCTAssertEqual(14, model.bookmarks.count)
        XCTAssertEqual("Weather Berlin - Google Search", model.bookmarks.first?.title)
        XCTAssertEqual("https://www.google.com/search?q=Weather%20Berlin", model.bookmarks.first?.access.value)
        XCTAssertEqual("EXPLAINED: How German citizenship differs from permanent residency", model.bookmarks.last?.title)
        XCTAssertEqual("https://www.thelocal.de/20211020/explained-how-german-citizenship-differs-from-permanent-residency/", model.bookmarks.last?.access.value)
    }
    
    @discardableResult private func migrate() async -> URL {
        let data = try! Data(contentsOf: Bundle.module.url(forResource: "Privacy", withExtension: "archive")!)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Privacy.archive")
        try! data.write(to: url)
        await cloud.migrate(url: url)
        return url
    }
}
