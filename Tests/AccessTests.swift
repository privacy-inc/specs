import XCTest
@testable import Specs

final class AccessTests: XCTestCase {
    func testWithURL() {
        XCTAssertNotNil(Access.with(url: URL(string: "privacy://hello%20world")!) as? Access.Deeplink)
        XCTAssertNotNil(Access.with(url: URL(string: "data:image/jpeg;base64")!) as? Access.Embed)
        XCTAssertNotNil(Access.with(url: URL(string: "about:blank")!) as? Access.Embed)
        XCTAssertNotNil(Access.with(url: URL(fileURLWithPath: NSTemporaryDirectory() + "file.html")) as? Access.Local)
        XCTAssertNotNil(Access.with(url: URL(string: "https://www.aguacate.com")!) as? Access.Remote)
        XCTAssertNotNil(Access.with(url: URL(string: "https://goprivacy.app")!) as? Access.Remote)
    }
    
    func testWithDataDeepLink() {
        let original = Access.with(url: URL(string: "privacy://hello%20world")!) as? Access.Deeplink
        var data = original!.data
        let prototyped = Access.with(data: &data) as? Access.Deeplink
        XCTAssertNotNil(prototyped)
        XCTAssertEqual(prototyped?.value, original?.value)
        XCTAssertEqual(prototyped?.scheme, original?.scheme)
    }
    
    func testWithDataEmbed() {
        let original = Access.with(url: URL(string: "data:image/jpeg;base64")!) as? Access.Embed
        var data = original?.data ?? .init()
        let prototyped = Access.with(data: &data) as? Access.Embed
        XCTAssertNotNil(prototyped)
        XCTAssertEqual(prototyped?.value, original?.value)
        XCTAssertEqual(prototyped?.prefix, original?.prefix)
    }
    
    func testWithDataLocal() {
        let original = Access.with(url: URL(fileURLWithPath: NSTemporaryDirectory() + "file.html")) as? Access.Local
        var data = original?.data ?? .init()
        let prototyped = Access.with(data: &data) as? Access.Local
        XCTAssertNotNil(prototyped)
        XCTAssertEqual(prototyped?.value, original?.value)
        XCTAssertEqual(prototyped?.file, original?.file)
        XCTAssertEqual(prototyped?.bookmark, original?.bookmark)
    }
    
    func testWithDataRemote() {
        let original = Access.with(url: URL(string: "https://www.aguacate.com")!) as? Access.Remote
        var data = original?.data ?? .init()
        let prototyped = Access.with(data: &data) as? Access.Remote
        XCTAssertNotNil(prototyped)
        XCTAssertEqual(prototyped?.value, original?.value)
        XCTAssertEqual(prototyped?.domain, original?.domain)
    }
}
