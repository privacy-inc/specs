import XCTest
@testable import Archivable
@testable import Specs

final class CloudPolicyTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testBlock() async {
//        if case .block = await cloud.policy(history: id, url: URL(string: "https://something.googleapis.com")!) {
//            
//        } else {
//            XCTFail()
//        }
//        
//        if case .allow = await cloud.policy(history: id, url: URL(string: "https://google.com")!) {
//
//        } else {
//            XCTFail()
//        }
    }
}
