import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudCardsTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .ephemeral
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
}
