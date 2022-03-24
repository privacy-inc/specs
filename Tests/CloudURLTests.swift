import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudURLTests: XCTestCase {
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
        
        XCTAssertNotEqual(idFirst, idSecond)
        
        let model = await cloud.model
        XCTAssertEqual(2, model.history.count)
        XCTAssertEqual(2, model.index)
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
            _ = await cloud.open(url: URL(string: "https://avocado.org")!)
        }
        
        waitForExpectations(timeout: 1)
    }
}
