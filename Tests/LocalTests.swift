import XCTest
@testable import Specs

final class LocalTests: XCTestCase {
    func testOpen() {
        let file = URL(fileURLWithPath: NSTemporaryDirectory() + "file.html")
        try! Data("hello world".utf8).write(to: file)
        XCTAssertEqual(URL(fileURLWithPath: NSTemporaryDirectory()).absoluteString + "file.html", Access.with(url: file).value)
        
        let local = Access.with(url: file) as? Access.Local
        XCTAssertNotNil(local)
        local?
            .open {
                XCTAssertEqual(URL(fileURLWithPath: NSTemporaryDirectory()).absoluteString.replacingOccurrences(of: "var/", with: "private/var/"), $1.absoluteString)
            }
    }
}
