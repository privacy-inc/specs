import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudHistoryTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .ephemeral
        subs = []
    }
    
    func testTitle() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.history.first?.website.title == "hello world" {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id = try! await self.cloud.search("something")
            await self.cloud.update(title: "hello world", history: id)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testIgnoreSameTitle() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.history.first?.website.title == "hello world" {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id = try! await self.cloud.search("something")
            await self.cloud.update(title: "hello world", history: id)
            await self.cloud.update(title: "hello world", history: id)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testReplaceOlder() async {
        let first = await cloud.open(url: URL(string: "https://avocado.org")!)
        let second = await cloud.open(url: URL(string: "https://avocado.org")!)
        let model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual(1, model.index)
        XCTAssertEqual(first, second)
        XCTAssertEqual(0, first)
    }
}
