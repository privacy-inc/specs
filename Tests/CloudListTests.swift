import XCTest
@testable import Archivable
@testable import Specs

final class CloudListTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!

    override func setUp() {
        cloud = .init()
    }
    
    func testEmptySearch() async {
        await cloud.history(url: URL(string: "https://aguacate.org")!, title: "")
        await cloud.history(url: .init(string: "https://aguacate.org")!, title: "hello world")
        
        var result = await cloud.list(filter: "")
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("hello world", result.first?.title)
        
        result = await cloud.list(filter: " ")
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("hello world", result.first?.title)
        
        result = await cloud.list(filter: "\n ")
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("hello world", result.first?.title)
    }
    
    func testEmptySearchNoSort() async {
        await cloud.history(url: .init(string: "https://a.org")!, title: "a")
        await cloud.history(url: .init(string: "https://b.org")!, title: "b")
        
        let result = await cloud.list(filter: "")
        XCTAssertEqual(2, result.count)
        XCTAssertEqual("b", result.first?.title)
        XCTAssertEqual("a", result.last?.title)
    }
    
    func testEmptyWebsites() async {
        let result = await cloud.list(filter: "hello world")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testNoMatch() async {
        await cloud.history(url: .init(string: "https://aguacate.org")!, title: "")
        await cloud.history(url: .init(string: "https://aguacate.org")!, title: "lorem ipsum")
        
        let result = await cloud.list(filter: "rekall")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testTitle() async {
        await cloud.history(url: .init(string: "https://aguacate.org")!, title: "")
        await cloud.history(url: .init(string: "https://aguacate.org")!, title: "lorem ipsum")
        
        let result = await cloud.list(filter: "lorem")
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("https://aguacate.org", result.first?.id)
        XCTAssertEqual("lorem ipsum", result.first?.title)
    }
    
    func testURL() async {
        await cloud.history(url: .init(string: "https://aguacate.org")!, title: "")
        
        let result = await cloud.list(filter: "agua")
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("https://aguacate.org", result.first?.id)
        XCTAssertEqual("", result.first?.title)
    }
    
    func testSort() async {
        let url1 = URL(string: "https://aguacate.org")!
        let url2 = URL(string: "https://lorem.org")!
        let url3 = URL(string: "https://loremipsum.org/1")!
        let url4 = URL(string: "https://loremipsum.org/0")!
        
        await cloud.history(url: url1, title: "")
        await cloud.history(url: url1, title: "lorem ipsum")
        
        await cloud.history(url: url2, title: "")
        await cloud.history(url: url2, title: "hello world")
        
        await cloud.history(url: url3, title: "")
        await cloud.history(url: url3, title: "ipsum lorem")
        
        await cloud.history(url: url4, title: "")
        await cloud.history(url: url4, title: "ipsum lorem")
        
        await cloud.history(url: .init(string: "https://ipsum.org")!, title: "")
        await cloud.history(url: .init(string: "https://fdafsas.org")!, title: "")
        await cloud.history(url: .init(string: "https://orem.org")!, title: "")
        await cloud.history(url: .init(string: "https://im.org")!, title: "")
        
        let result = await cloud.list(filter: "lorem ipsum")
        XCTAssertEqual(5, result.count)
        XCTAssertEqual(url4.absoluteString, result.first?.id)
        XCTAssertEqual("ipsum lorem", result.first?.title)
        
        XCTAssertEqual(url3.absoluteString, result[1].id)
        XCTAssertEqual("ipsum lorem", result[1].title)
        
        XCTAssertEqual(url2.absoluteString, result.last?.id)
        XCTAssertEqual("hello world", result.last?.title)
    }
    
    func testSortTitles() async {
        await cloud.history(url: .init(string: "https://aguacate.org")!, title: "")
        await cloud.history(url: .init(string: "https://aguacate.org")!, title: "world")
        
        await cloud.history(url: .init(string: "https://lorem.org")!, title: "")
        await cloud.history(url: .init(string: "https://lorem.org")!, title: "hello")
        
        let result = await cloud.list(filter: "hello world")
        XCTAssertEqual("hello", result.first?.title)
        XCTAssertEqual("world", result.last?.title)
    }
}
