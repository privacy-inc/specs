import XCTest
@testable import Archivable
@testable import Specs

final class CloudAutocompleteTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    
    override func setUp() {
        cloud = .ephemeral
    }
    
    func testEmpty() async {
        var result = try? await cloud.autocomplete(search: "")
        XCTAssertNil(result)
        
        result = try? await cloud.autocomplete(search: " ")
        XCTAssertNil(result)
        
        result = try? await cloud.autocomplete(search: "\n ")
        XCTAssertNil(result)
    }
    
    func testNothing() async {
        let result = try? await cloud.autocomplete(search: "hello world")
        XCTAssertNil(result)
    }
    
    func testTitle() async {
        let id = await cloud.open(url: URL(string: "https://aguacate.org")!)
        await cloud.update(title: "lorem ipsum", history: id)
        
        let result = try? await cloud.autocomplete(search: "lorem")
        XCTAssertEqual(1, result?.count)
        XCTAssertEqual("https://aguacate.org", result?.first?.access.value)
        XCTAssertEqual("lorem ipsum", result?.first?.title)
        XCTAssertEqual("aguacate.org", result?.first?.domain)
    }
    
    func testURL() async {
        _ = await cloud.open(url: URL(string: "https://aguacate.org")!)
        
        let result = try? await cloud.autocomplete(search: "agua")
        XCTAssertEqual(1, result?.count)
        XCTAssertEqual("https://aguacate.org", result?.first?.access.value)
        XCTAssertEqual("", result?.first?.title)
        XCTAssertEqual("aguacate.org", result?.first?.domain)
    }
    
    func testSort() async {
        let id1 = await cloud.open(url: URL(string: "https://aguacate.org")!)
        await cloud.update(title: "lorem ipsum", history: id1)
        
        let id2 = await cloud.open(url: URL(string: "https://lorem.org")!)
        await cloud.update(title: "hello world", history: id2)
        
        let id3 = await cloud.open(url: URL(string: "https://loremipsum.org/1")!)
        await cloud.update(title: "ipsum lorem", history: id3)
        
        let id4 = await cloud.open(url: URL(string: "https://loremipsum.org/0")!)
        await cloud.update(title: "ipsum lorem", history: id4)
        
        _ = await cloud.open(url: URL(string: "https://ipsum.org")!)
        
        _ = await cloud.open(url: URL(string: "https://fdafsas.org")!)
        
        _ = await cloud.open(url: URL(string: "https://orem.org")!)
        
        _ = await cloud.open(url: URL(string: "https://im.org")!)
        
        let result = try? await cloud.autocomplete(search: "lorem ipsum")
        XCTAssertEqual(5, result?.count)
        XCTAssertEqual("https://loremipsum.org/0", result?.first?.access.value)
        XCTAssertEqual("ipsum lorem", result?.first?.title)
        XCTAssertEqual("loremipsum.org", result?.first?.domain)
        
        XCTAssertEqual("https://loremipsum.org/1", result?[1].access.value)
        XCTAssertEqual("ipsum lorem", result?[1].title)
        XCTAssertEqual("loremipsum.org", result?[1].domain)
        
        XCTAssertEqual("https://lorem.org", result?.last?.access.value)
        XCTAssertEqual("hello world", result?.last?.title)
        XCTAssertEqual("lorem.org", result?.last?.domain)
    }
    
    func testSortTitles() async {
        let id1 = await cloud.open(url: URL(string: "https://aguacate.org")!)
        await cloud.update(title: "world", history: id1)
        
        let id2 = await cloud.open(url: URL(string: "https://lorem.org")!)
        await cloud.update(title: "hello", history: id2)
        
        let result = try? await cloud.autocomplete(search: "hello world")
        XCTAssertEqual("hello", result?.first?.title)
        XCTAssertEqual("world", result?.last?.title)
    }
}
