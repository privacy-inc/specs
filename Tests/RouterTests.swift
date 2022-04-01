import XCTest
@testable import Specs

final class RouterTests: XCTestCase {
    func testWithURL() {
        XCTAssertEqual(.deeplink, Router.with(url: URL(string: "privacy://hello%20world")!))
        XCTAssertEqual(.embed(.data), Router.with(url: URL(string: "data:image/jpeg;base64")!))
        XCTAssertEqual(.embed(.about), Router.with(url: URL(string: "about:blank")!))
        XCTAssertEqual(.remote, Router.with(url: URL(string: "https://www.aguacate.com")!))
        XCTAssertEqual(.remote, Router.with(url: URL(string: "https://goprivacy.app")!))
        
        if case .local = Router.with(url: URL(fileURLWithPath: NSTemporaryDirectory() + "file.html")) { } else {
            XCTFail()
        }
    }
}
