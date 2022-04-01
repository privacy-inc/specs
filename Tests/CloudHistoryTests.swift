import XCTest
@testable import Archivable
@testable import Specs

final class CloudHistoryTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testOpenURL() async {
        await cloud.open(url: .init(string: "avocado.org")!)
        var model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual("avocado.org", model.history.first?.id)
        XCTAssertEqual("", model.history.first?.title)
        
        await cloud.open(url: .init(string: "data:some")!)
        await cloud.open(url: .init(string: "file:///local/file.txt")!)
        await cloud.open(url: .init(string: "hello://unfresh")!)
        
        model = await cloud.model
        XCTAssertEqual(1, model.history.count)
    }
    
    func testUpdateTitle() async {
        let url = try! await cloud.search("something")
        await cloud.update(title: "hello world", url: url)
        let model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual(url.absoluteString, model.history.first?.id)
        XCTAssertEqual("hello world", model.history.first?.title)
    }
    
    func testReplace() async {
        await cloud.open(url: .init(string: "https://first.org")!)
        await cloud.open(url: .init(string: "https://second.org")!)
        await cloud.open(url: .init(string: "https://third.org")!)
        await cloud.open(url: .init(string: "https://first.org")!)
        
        var model = await cloud.model
        XCTAssertEqual(3, model.history.count)
        XCTAssertEqual("https://first.org", model.history.first?.id)
        XCTAssertEqual("https://second.org", model.history.last?.id)
        
        await cloud.open(url: .init(string: "http://first.org")!)
        
        model = await cloud.model
        XCTAssertEqual(3, model.history.count)
        XCTAssertEqual("http://first.org", model.history.first?.id)
    }
    
    func testDelete() async {
        await cloud.open(url: .init(string: "https://first.org")!)
        await cloud.open(url: .init(string: "https://second.org")!)
        await cloud.delete(history: 1)
        
        let model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual("https://second.org", model.history.first?.id)
    }
}
