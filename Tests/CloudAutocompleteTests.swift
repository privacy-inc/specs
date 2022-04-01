import XCTest
@testable import Archivable
@testable import Specs

final class CloudAutocompleteTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!

    override func setUp() {
        cloud = .init()
    }
    
    func testEmptySearch() async {
        await cloud.open(url: URL(string: "https://aguacate.org")!)
        await cloud.update(title: "hello world", url: .init(string: "https://aguacate.org")!)
        
        var result = await cloud.autocomplete(search: "")
        XCTAssertTrue(result.isEmpty)
        
        result = await cloud.autocomplete(search: " ")
        XCTAssertTrue(result.isEmpty)
        
        result = await cloud.autocomplete(search: "\n ")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testEmptyWebsites() async {
        let result = await cloud.autocomplete(search: "hello world")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testTitle() async {
        await cloud.open(url: .init(string: "https://aguacate.org")!)
        await cloud.update(title: "lorem ipsum", url: .init(string: "https://aguacate.org")!)
        
        let result = await cloud.autocomplete(search: "lorem")
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("https://aguacate.org", result.first?.id)
        XCTAssertEqual("lorem ipsum", result.first?.title)
    }
    
    func testURL() async {
        await cloud.open(url: .init(string: "https://aguacate.org")!)
        
        let result = await cloud.autocomplete(search: "agua")
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("https://aguacate.org", result.first?.id)
        XCTAssertEqual("", result.first?.title)
    }
    
    func testSort() async {
        let url1 = URL(string: "https://aguacate.org")!
        let url2 = URL(string: "https://lorem.org")!
        let url3 = URL(string: "https://loremipsum.org/1")!
        let url4 = URL(string: "https://loremipsum.org/0")!
        
        await cloud.open(url: url1)
        await cloud.update(title: "lorem ipsum", url: url1)
        
        await cloud.open(url: url2)
        await cloud.update(title: "hello world", url: url2)
        
        await cloud.open(url: url3)
        await cloud.update(title: "ipsum lorem", url: url3)
        
        await cloud.open(url: url4)
        await cloud.update(title: "ipsum lorem", url: url4)
        
        await cloud.open(url: .init(string: "https://ipsum.org")!)
        await cloud.open(url: .init(string: "https://fdafsas.org")!)
        await cloud.open(url: .init(string: "https://orem.org")!)
        await cloud.open(url: .init(string: "https://im.org")!)
        
        let result = await cloud.autocomplete(search: "lorem ipsum")
        XCTAssertEqual(5, result.count)
        XCTAssertEqual(url4.absoluteString, result.first?.id)
        XCTAssertEqual("ipsum lorem", result.first?.title)
        
        XCTAssertEqual(url3.absoluteString, result[1].id)
        XCTAssertEqual("ipsum lorem", result[1].title)
        
        XCTAssertEqual(url2.absoluteString, result.last?.id)
        XCTAssertEqual("hello world", result.last?.title)
    }
    
    func testSortTitles() async {
        await cloud.open(url: .init(string: "https://aguacate.org")!)
        await cloud.update(title: "world", url: .init(string: "https://aguacate.org")!)
        
        await cloud.open(url: .init(string: "https://lorem.org")!)
        await cloud.update(title: "hello", url: .init(string: "https://lorem.org")!)
        
        let result = await cloud.autocomplete(search: "hello world")
        XCTAssertEqual("hello", result.first?.title)
        XCTAssertEqual("world", result.last?.title)
    }
}
