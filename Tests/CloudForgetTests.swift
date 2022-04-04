import XCTest
@testable import Archivable
@testable import Specs

final class CloudForgetTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testClear() async {
        await cloud.history(url: URL(string: "https://avocado.org")!, title: "")
        _ = await cloud.policy(request: .init(string: "https://something.googleapis.com")!, from: .init(string: "https://google.com")!)
        await cloud.forget()
        
        let model = await cloud.model
        XCTAssertTrue(model.history.isEmpty)
        XCTAssertEqual(0, model.tracking.total)
    }
}
