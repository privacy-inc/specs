import XCTest
@testable import Archivable
@testable import Specs

final class CloudSearchTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testSearch() async {
        let first = try! await cloud.search("hello world")
        XCTAssertTrue(first.absoluteString.contains("hello"))
        
        let model = await cloud.model
        XCTAssertTrue(model.history.isEmpty)
    }
    
    func testInvalidSearch() async {
        _ = try? await cloud.search("")

        let model = await cloud.model
        XCTAssertTrue(model.history.isEmpty)
    }
}
