import XCTest
@testable import Specs

final class LocalTests: XCTestCase {
    func testOpen() {
        let file = URL(fileURLWithPath: NSTemporaryDirectory() + "file.html")
        try! Data("hello world".utf8).write(to: file)
        
        if case let .local(data) = Router.with(url: file) {
            XCTAssertEqual(URL(fileURLWithPath: NSTemporaryDirectory()).absoluteString.replacingOccurrences(of: "var/", with: "private/var/"), data.bookmark?.absoluteString)
        } else {
            XCTFail()
        }
    }
}
