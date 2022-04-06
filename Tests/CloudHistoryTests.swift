import XCTest
@testable import Archivable
@testable import Specs

final class CloudHistoryTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testOpenURL() async {
        await cloud.history(url: .init(string: "http://avocado.org")!, title: "")
        var model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual("http://avocado.org", model.history.first?.id)
        XCTAssertEqual("", model.history.first?.title)
        
        await cloud.history(url: .init(string: "data:some")!, title: "")
        await cloud.history(url: .init(string: "file:///local/file.txt")!, title: "")
        await cloud.history(url: .init(string: "hello://unfresh")!, title: "")
        
        model = await cloud.model
        XCTAssertEqual(1, model.history.count)
    }
    
    func testUpdateTitle() async {
        let url = try! await cloud.search("something")
        await cloud.history(url: url, title: "hello world")
        let model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual(url.absoluteString, model.history.first?.id)
        XCTAssertEqual("hello world", model.history.first?.title)
    }
    
    func testReplace() async {
        await cloud.history(url: .init(string: "https://first.org")!, title: "")
        await cloud.history(url: .init(string: "https://second.org")!, title: "")
        await cloud.history(url: .init(string: "https://third.org")!, title: "")
        await cloud.history(url: .init(string: "http://first.org")!, title: "")
        await cloud.history(url: .init(string: "https://www.first.org")!, title: "")
        await cloud.history(url: .init(string: "https://mobile.first.org")!, title: "")
        await cloud.history(url: .init(string: "https://a.b.c.d.first.org")!, title: "")
        await cloud.history(url: .init(string: "https://first.org")!, title: "")
        
        var model = await cloud.model
        XCTAssertEqual(3, model.history.count)
        XCTAssertEqual("https://first.org", model.history.first?.id)
        XCTAssertEqual("https://second.org", model.history.last?.id)
        
        await cloud.history(url: .init(string: "http://first.org/as")!, title: "")
        
        model = await cloud.model
        XCTAssertEqual(4, model.history.count)
        XCTAssertEqual("http://first.org/as", model.history.first?.id)
    }
    
    func testDelete() async {
        await cloud.history(url: .init(string: "https://first.org")!, title: "")
        await cloud.history(url: .init(string: "https://second.org")!, title: "")
        await cloud.delete(url: "https://first.org")
        
        let model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual("https://second.org", model.history.first?.id)
    }
    
    func testNoHistoryIfBookmark() async {
        let url = URL(string: "https://hello.world.app")!
        await cloud.bookmark(url: url, title: "hello world")
        await cloud.history(url: url, title: "world hello")
        let model = await cloud.model
        XCTAssertTrue(model.history.isEmpty)
        XCTAssertEqual(1, model.bookmarks.count)
    }
}
