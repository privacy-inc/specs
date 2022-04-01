import XCTest
import Combine
@testable import Archivable
@testable import Specs
/*
final class CloudPolicyTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init()
        subs = []
    }
    
    func testBlock() {
        let expect = expectation(description: "")
        
        cloud
            .dropFirst()
            .sink {
                if $0.events.domains.count == 2 {
                    XCTAssertEqual(1, $0.events.trackers.count)
                    XCTAssertEqual(1, $0.events.items.first?.trackers.count)
                    XCTAssertEqual(2, $0.events.items.count)
                    XCTAssertEqual(1, $0.events.timestamps.count)
                    XCTAssertEqual("something.googleapis.com", $0.events.trackers.first)
                    XCTAssertEqual("avocado.org", $0.events.domains.first)
                    XCTAssertEqual("google.com", $0.events.domains.last)
                    XCTAssertEqual(0, $0.events.items.first?.domain)
                    XCTAssertEqual(0, $0.events.items.first?.timestamp)
                    XCTAssertEqual(1, $0.events.items.first?.trackers.count)
                    XCTAssertEqual(0, $0.events.items.first?.trackers.first)
                    expect.fulfill()
                }
            }
            .store(in: &subs)
        
        Task {
            let id = await cloud.open(url: URL(string: "https://avocado.org")!)
            
            if case .block = await cloud.policy(history: id, url: URL(string: "https://something.googleapis.com")!) {
                
            } else {
                XCTFail()
            }
            
            if case .allow = await cloud.policy(history: id, url: URL(string: "https://google.com")!) {

            } else {
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
*/
