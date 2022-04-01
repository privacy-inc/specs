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
    
    func testBookmark() {
        let file = URL(fileURLWithPath: NSTemporaryDirectory() + "file.html")
        try! Data("hello world".utf8).write(to: file)
        
        if case let .local(data) = Router.with(url: file) {
            XCTAssertEqual(URL(fileURLWithPath: NSTemporaryDirectory()).absoluteString.replacingOccurrences(of: "var/", with: "private/var/"), data.bookmark?.absoluteString)
        } else {
            XCTFail()
        }
    }
    
    func testDomain() {
        XCTAssertEqual("", "https://".domain)
        XCTAssertEqual("", "".domain)
        XCTAssertEqual("wds", "wds".domain)
        XCTAssertEqual("linkedin.com", "https://www.linkedin.com/authwall?trk=bf&trkInfo=bf&originalReferer=https://www.google.com&sessionRedirect=https%3A%2F%2Fde.linkedin.com%2Fin%2Fedal%25C3%25AD-c%25C3%25A1rdenas-beltr%25C3%25A1n-38670510a".domain)
        XCTAssertEqual("linkedin.com", "www.linkedin.com/authwall?trk=bf&trkInfo=bf&originalReferer=https://www.google.com&sessionRedirect=https%3A%2F%2Fde.linkedin.com%2Fin%2Fedal%25C3%25AD-c%25C3%25A1rdenas-beltr%25C3%25A1n-38670510a".domain)
        XCTAssertEqual("hello.com", "www.hello.com".domain)
        XCTAssertEqual("hello.com", "www.hello.com/lol".domain)
        XCTAssertEqual("hello.com", "www.hello.com:8080".domain)
        XCTAssertEqual("hello.com", "www.hello.com:8080/lol".domain)
        XCTAssertEqual("world.com", "www.hello.world.com/lol".domain)
        XCTAssertEqual("world.com", "https://hello.world.com/lol".domain)
        XCTAssertEqual("bbc.co.uk", "https://bbc.co.uk".domain)
        XCTAssertEqual("privacy-inc.github.io", "https://privacy-inc.github.io/about".domain)
    }
}
