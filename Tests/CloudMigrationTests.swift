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
        
        waitForExpectations(timeout: 5)
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
    
    func testWebsites() async {
        await migrate()
        let model = await cloud.model
        
        XCTAssertEqual(1830, model.history.count)
        XCTAssertEqual(2290, model.history.first?.id)
        XCTAssertEqual("Igoumenitsa - Wikipedia", model.history.first?.website.title)
        XCTAssertEqual("https://en.wikipedia.org/wiki/Igoumenitsa", model.history.first?.website.access.value)
        XCTAssertEqual("Adrien Brody: ‘Actors are attention seekers. But I’m an introvert’ | Adrien Brody | The Guardian", model.history.last?.website.title)
        XCTAssertEqual("https://www.theguardian.com/global/2021/oct/24/adrien-brody-interview-actors-are-attention-seekers-but-i-am-an-introvert", model.history.last?.website.access.value)
        XCTAssertEqual(0, model.history.last?.id)
        XCTAssertEqual(2291, model.index)
    }
    
    @discardableResult private func migrate() async -> URL {
        let data = try! Data(contentsOf: Bundle.module.url(forResource: "Privacy", withExtension: "archive")!)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Privacy.archive")
        try! data.write(to: url)
        await cloud.migrate(url: url)
        return url
    }
}
