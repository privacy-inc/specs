import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudBookmarksTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init()
        subs = []
    }
    
    func testAdd() async {
        _ = await cloud.open(url: URL(string: "https://lorem.com")!)
        let id = await cloud.open(url: URL(string: "https://avocado.org")!)
        _ = await cloud.open(url: URL(string: "https://ipsum.com")!)
        
        await cloud.update(title: "hello world", history: id)
        await cloud.bookmark(history: id)
        
        let model = await cloud.model
        XCTAssertEqual(1, model.bookmarks.count)
        XCTAssertEqual("hello world", model.bookmarks.first?.title)
        XCTAssertTrue(model.bookmarks.first?.access.value.contains("avocado.org") ?? false)
    }
    
    func testSave() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if !$0.bookmarks.isEmpty {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id = await cloud.open(url: URL(string: "https://avocado.org")!)
            await cloud.bookmark(history: id)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testRemoveDuplicatedURL() async {
        let id1 = await cloud.open(url: URL(string: "https://avocado.org")!)
        _ = await cloud.open(url: URL(string: "https://lorem.org")!)
        let id3 = await cloud.open(url: URL(string: "https://avocado.org")!)
        
        await cloud.update(title: "hello world", history: id1)
        await cloud.update(title: "total recall", history: id3)
        
        await cloud.bookmark(history: id3)
        await cloud.bookmark(history: id1)
        
        let model = await cloud.model
        XCTAssertEqual(model.bookmarks.first?.access.value, model.bookmarks.last?.access.value)
        XCTAssertEqual(1, model.bookmarks.count)
    }
    
    func testDelete() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        cloud
            .sink {
                if $0.bookmarks.isEmpty && $0.index == 1 {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id = await cloud.open(url: URL(string: "https://avocado.org")!)
            await cloud.bookmark(history: id)
            await cloud.delete(bookmark: 0)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testMove() async {
        let id1 = await cloud.open(url: URL(string: "https://lorem.com")!)
        let id2 = await cloud.open(url: URL(string: "https://ipsum.com")!)
        
        await cloud.bookmark(history: id1)
        await cloud.bookmark(history: id2)
        
        await cloud.move(bookmark: 1, to: 0)
        
        let model = await cloud.model
        XCTAssertTrue(model.bookmarks.first?.access.value.contains("ipsum.com") ?? false)
        XCTAssertTrue(model.bookmarks.last?.access.value.contains("lorem.com") ?? false)
    }
    
    func testMoveSave() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.bookmarks.first?.access.value.contains("ipsum.com") == true {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id1 = await cloud.open(url: URL(string: "https://lorem.com")!)
            let id2 = await cloud.open(url: URL(string: "https://ipsum.com")!)
            
            await cloud.bookmark(history: id1)
            await cloud.bookmark(history: id2)

            await cloud.move(bookmark: 1, to: 0)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testDontSaveSame() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.bookmarks.count == 2 {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id1 = await cloud.open(url: URL(string: "https://lorem.com")!)
            let id2 = await cloud.open(url: URL(string: "https://ipsum.com")!)
            
            await cloud.bookmark(history: id1)
            await cloud.bookmark(history: id2)

            await cloud.move(bookmark: 1, to: 1)
        }
        
        waitForExpectations(timeout: 1)
    }
}
