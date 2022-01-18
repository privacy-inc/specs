import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudSearchTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init()
        subs = []
    }
    
    func testFirsts() async {
        let idFirst = try! await cloud.search("hello world")
        XCTAssertEqual(0, idFirst)
        
        var model = await cloud.model
        XCTAssertEqual(0, model.history.first?.id)
        XCTAssertEqual(1, model.index)
        XCTAssertTrue(model.history.first?.website.access.value.contains("hello") ?? false)
        
        let idSecond = try! await cloud.search("lorem ipsum")
        XCTAssertEqual(1, idSecond)
        
        model = await cloud.model
        XCTAssertEqual(1, model.history.first?.id)
        XCTAssertEqual(0, model.history.last?.id)
        XCTAssertEqual(2, model.index)
        XCTAssertTrue(model.history.first?.website.access.value.contains("lorem") ?? false)
        XCTAssertTrue(model.history.last?.website.access.value.contains("hello") ?? false)
    }
    
    func testDuplicates() async {
        _ = try! await cloud.search("hello world")
        let last = try! await cloud.search("hello world")
        
        XCTAssertEqual(1, last)
        
        let model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual(1, model.history.first?.id)
        XCTAssertEqual(2, model.index)
    }
    
    func testInvalidSearch() async {
        _ = try? await cloud.search("")

        let model = await cloud.model
        XCTAssertTrue(model.history.isEmpty)
    }
    
    func testReuseHistory() async {
        let id = try! await cloud.search("hello world")
        XCTAssertEqual(0, id)
        
        try! await cloud.search("lorem ipsum", history: id)
        
        let model = await cloud.model
        XCTAssertEqual(0, model.history.first?.id)
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual(1, model.index)
        XCTAssertTrue(model.history.first?.website.access.value.contains("lorem") ?? false)
    }
    
    func testInvalidSearchReuse() async {
        let id = try! await cloud.search("hello world")
        XCTAssertEqual(0, id)
        
        try? await cloud.search("", history: id)
        
        let model = await cloud.model
        XCTAssertEqual(0, model.history.first?.id)
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual(1, model.index)
        XCTAssertTrue(model.history.first?.website.access.value.contains("hello") ?? false)
    }
    
    func testSaves() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.history.count == 1 {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            _ = try! await cloud.search("something")
        }
        
        waitForExpectations(timeout: 1)
    }
}
