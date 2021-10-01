import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudAccessTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .ephemeral
        subs = []
    }
    
    func testFirsts() async {
        let idFirst = await cloud.open(url: URL(string: "https://avocado.org")!)
        XCTAssertEqual(0, idFirst)
        
        let idSecond = await cloud.open(url: URL(string: "https://something.org")!)
        XCTAssertEqual(1, idSecond)
        
        let access = await cloud.model.history.first!.website.access
        let idThird = await cloud.open(access: access)
        
        XCTAssertNotEqual(idFirst, idSecond)
        XCTAssertEqual(idSecond, idThird)
        
        let model = await cloud.model
        XCTAssertEqual(2, model.history.count)
        XCTAssertEqual(2, model.index)
    }
    
    func testSaves() {
        let expect = expectation(description: "")
        
        cloud
            .sink {
                if $0.index == 2 {
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            _ = await cloud.open(url: URL(string: "https://avocado.org")!)
            _ = await cloud.open(access: Access.with(url: URL(string: "https://something.com")!))
        }
        
        waitForExpectations(timeout: 1)
    }
}
