import XCTest
import Combine
@testable import Archivable
@testable import Specs
/*
final class CloudAccessTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init()
        subs = []
    }
    
    func testFirsts() async {
        let idFirst = await cloud.open(url: URL(string: "https://avocado.org")!)
        XCTAssertEqual(0, idFirst)
        
        let idSecond = await cloud.open(url: URL(string: "https://something.org")!)
        XCTAssertEqual(1, idSecond)
        
        let access = await cloud.model.history.first!.website.access as! Access.Remote
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
            _ = await cloud.open(access: Access.with(url: URL(string: "https://something.com")!) as! Access.Remote)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testOpenWithHistory() async {
        _ = await cloud.open(url: URL(string: "https://avocado.org")!)
        let idSecond = await cloud.open(url: URL(string: "https://something.org")!)
        
        let access = await cloud.model.history.last!.website.access as! Access.Remote
        await cloud.open(access: access, history: idSecond)
        
        let model = await cloud.model
        XCTAssertEqual(1, model.history.count)
        XCTAssertEqual(2, model.index)
    }
}
*/
