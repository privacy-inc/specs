import XCTest
@testable import Archivable
@testable import Specs

final class CloudBookmarksTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testAdd() async {
        await cloud.bookmark(url: .init(string: "https://avocado.org")!, title: "Some avocado")
        
        let model = await cloud.model
        XCTAssertEqual(1, model.bookmarks.count)
        XCTAssertEqual("Some avocado", model.bookmarks.first?.title)
        XCTAssertEqual("https://avocado.org", model.bookmarks.first?.id)
    }
    
    func testRemoveDuplicatedURL() async {
        await cloud.bookmark(url: .init(string: "https://avocado.org")!, title: "Some avocado a")
        await cloud.bookmark(url: .init(string: "https://avocado.org")!, title: "Some avocado b")
        await cloud.bookmark(url: .init(string: "avocado.org")!, title: "Some avocado c")
        await cloud.bookmark(url: .init(string: "http://avocado.org")!, title: "Some avocado last")
        
        let model = await cloud.model
        XCTAssertEqual(1, model.bookmarks.count)
        XCTAssertEqual("Some avocado last", model.bookmarks.first?.title)
        XCTAssertEqual("http://avocado.org", model.bookmarks.first?.id)
    }
    
    func testDelete() async {
        await cloud.bookmark(url: .init(string: "https://first.org")!, title: "a")
        await cloud.bookmark(url: .init(string: "https://second.org")!, title: "b")
        await cloud.delete(bookmark: 1)
        
        let model = await cloud.model
        XCTAssertEqual(1, model.bookmarks.count)
        XCTAssertEqual("https://first.org", model.bookmarks.first?.id)
    }
    
    func testMove() async {
        await cloud.bookmark(url: .init(string: "https://first.org")!, title: "a")
        await cloud.bookmark(url: .init(string: "https://second.org")!, title: "b")
        
        await cloud.move(bookmark: 1, to: 0)
        
        let model = await cloud.model
        XCTAssertEqual("https://second.org", model.bookmarks.first?.id)
        XCTAssertEqual("https://first.org", model.bookmarks.last?.id)
    }
    
    func testClearHistory() async {
        let url = URL(string: "https://hello.world.app")!
        await cloud.history(url: url, title: "world hello")
        await cloud.bookmark(url: url, title: "hello world")
        let model = await cloud.model
        XCTAssertTrue(model.history.isEmpty)
        XCTAssertEqual(1, model.bookmarks.count)
    }
}

