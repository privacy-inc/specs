import XCTest
@testable import Archivable
@testable import Specs

final class CloudPolicyTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testAllow() async {
        let response = await cloud.policy(request: .init(string: "https://google.com")!, from: .init(string: "https://google.com")!)
        XCTAssertEqual(.allow, response)
    }
    
    func testBlock() async {
        if case .block = await cloud.policy(request: .init(string: "https://something.googleapis.com")!, from: .init(string: "https://google.com")!) {
            let tracking = await cloud.model.tracking.items(for: "google.com")
            XCTAssertEqual([.init(tracker: "googleapis", count: 1)], tracking)
        } else {
            XCTFail()
        }
    }
}
