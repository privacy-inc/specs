import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudHistoryTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init()
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
            let id = try! await cloud.search("something")
            await cloud.update(title: "hello world", history: id)
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
            let id = try! await cloud.search("something")
            await cloud.update(title: "hello world", history: id)
            await cloud.update(title: "hello world", history: id)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testURL() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.history.first?.website.access.value == "https://avocado.org" {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id = try! await cloud.search("something")
            await cloud.update(url: URL(string: "https://avocado.org")!, history: id)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testIgnoreSameURL() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.history.first?.website.access.value == "https://avocado.org" {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id = try! await cloud.search("something")
            await cloud.update(url: URL(string: "https://avocado.org")!, history: id)
            await cloud.update(url: URL(string: "https://avocado.org")!, history: id)
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
    
    func testDelete() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.history.isEmpty && $0.index == 1 {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id = try! await cloud.search("something")
            await cloud.delete(history: id)
        }
        
        waitForExpectations(timeout: 1)
    }
}
