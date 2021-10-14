import XCTest
@testable import Archivable
@testable import Specs

final class CloudFindTests: XCTestCase {
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
}
