import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudSearchTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .ephemeral
        subs = []
    }
    
    func testFirsts() async {
        let idFirst = await cloud.search("hello world")
        XCTAssertEqual(0, idFirst)
        
        var model = await cloud.model
        XCTAssertEqual(0, model.history.first?.id)
        XCTAssertEqual(1, model.index)
        XCTAssertTrue(model.history.first?.website.access.value.contains("hello") ?? false)
        
        let idSecond = await cloud.search("lorem ipsum")
        XCTAssertEqual(1, idSecond)
        
        model = await cloud.model
        XCTAssertEqual(1, model.history.first?.id)
        XCTAssertEqual(0, model.history.last?.id)
        XCTAssertEqual(2, model.index)
        XCTAssertTrue(model.history.first?.website.access.value.contains("lorem") ?? false)
        XCTAssertTrue(model.history.last?.website.access.value.contains("hello") ?? false)
    }
    
    func testDuplicates() async {
        _ = await cloud.search("hello world")
        let last = await cloud.search("hello world")
        
        XCTAssertEqual(1, last)
        
        let model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual(1, model.history.first?.id)
        XCTAssertEqual(2, model.index)
    }
}
