import XCTest
@testable import Archivable
@testable import Specs

final class CloudForgetTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testClear() async {
        await cloud.open(url: URL(string: "https://avocado.org")!)
        await cloud.forget()
        
        let model = await cloud.model
        XCTAssertTrue(model.history.isEmpty)
    }
}
