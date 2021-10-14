import XCTest
@testable import Specs

final class AccessTests: XCTestCase {
    func testWithURL() {
        XCTAssertEqual(.deeplink, (Access.with(url: URL(string: "privacy://hello%20world")!) as? Access.Other)?.key)
        XCTAssertEqual(.embed, (Access.with(url: URL(string: "data:image/jpeg;base64")!) as? Access.Other)?.key)
        XCTAssertEqual(.embed, (Access.with(url: URL(string: "about:blank")!) as? Access.Other)?.key)
        XCTAssertNotNil(Access.with(url: URL(fileURLWithPath: NSTemporaryDirectory() + "file.html")) as? Access.Local)
        XCTAssertNotNil(Access.with(url: URL(string: "https://www.aguacate.com")!) as? Access.Remote)
        XCTAssertNotNil(Access.with(url: URL(string: "https://goprivacy.app")!) as? Access.Remote)
    }
    
    func testWithDataDeepLink() {
        let original = Access.with(url: URL(string: "privacy://hello%20world")!) as? Access.Other
        var data = original!.data
        let prototyped = Access.with(data: &data) as? Access.Other
        XCTAssertNotNil(prototyped)
        XCTAssertEqual(prototyped?.value, original?.value)
        XCTAssertEqual(.deeplink, prototyped?.key)
    }
    
    func testWithDataEmbed() {
        let original = Access.with(url: URL(string: "data:image/jpeg;base64")!) as? Access.Other
        var data = original?.data ?? .init()
        let prototyped = Access.with(data: &data) as? Access.Other
        XCTAssertNotNil(prototyped)
        XCTAssertEqual(prototyped?.value, original?.value)
        XCTAssertEqual(.embed, prototyped?.key)
    }
    
    func testWithDataLocal() {
        let original = Access.with(url: URL(fileURLWithPath: NSTemporaryDirectory() + "file.html")) as? Access.Local
        var data = original?.data ?? .init()
        let prototyped = Access.with(data: &data) as? Access.Local
        XCTAssertNotNil(prototyped)
        XCTAssertEqual(prototyped?.value, original?.value)
        XCTAssertEqual(prototyped?.bookmark, original?.bookmark)
    }
    
    func testWithDataRemote() {
        let original = Access.with(url: URL(string: "https://www.aguacate.com")!) as? Access.Remote
        var data = original?.data ?? .init()
        let prototyped = Access.with(data: &data) as? Access.Remote
        XCTAssertNotNil(prototyped)
        XCTAssertEqual(prototyped?.value, original?.value)
        XCTAssertEqual(prototyped?.domain.minimal, original?.domain.minimal)
    }
}
