import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudForgetTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init()
        subs = []
    }
    
    func testHistory() async {
        _ = await cloud.open(url: URL(string: "https://avocado.org")!)
        await cloud.forgetHistory()
        
        let model = await cloud.model
        XCTAssertTrue(model.history.isEmpty)
        XCTAssertEqual(0, model.index)
    }
    
    func testHistorySaves() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            await cloud.forgetHistory()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testActivity() async {
        let id = await cloud.open(url: URL(string: "https://avocado.org")!)
        _ = await cloud.policy(history: id, url: URL(string: "https://something.com")!)
        
        Task
            .detached(priority: .utility) {
                var model = await self.cloud.model
                XCTAssertEqual(1, model.events.items.count)
                await self.cloud.forgetActivity()
                
                model = await self.cloud.model
                XCTAssertEqual(1, model.index)
                XCTAssertTrue(model.events.items.isEmpty)
            }
    }
    
    func testActivitySaves() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            await cloud.forgetActivity()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAll() async {
        let id = await cloud.open(url: URL(string: "https://avocado.org")!)
        _ = await cloud.policy(history: id, url: URL(string: "https://something.com")!)
        
        Task
            .detached(priority: .utility) {
                var model = await self.cloud.model
                XCTAssertEqual(1, model.events.items.count)
                await self.cloud.forget()
                
                model = await self.cloud.model
                XCTAssertTrue(model.events.items.isEmpty)
                XCTAssertTrue(model.history.isEmpty)
                XCTAssertEqual(0, model.index)
            }
    }
    
    func testAllSaves() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            await cloud.forget()
        }
        
        waitForExpectations(timeout: 1)
    }
}
