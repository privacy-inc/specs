import XCTest
@testable import Specs

final class RemoteTests: XCTestCase {
    func testDomain() {
        XCTAssertEqual("", Access.Remote(value: "https://").domain)
        XCTAssertEqual("", Access.Remote(value: "").domain)
        XCTAssertEqual("wds", Access.Remote(value: "wds").domain)
        XCTAssertEqual("linkedin", Access.Remote(value: "https://www.linkedin.com/authwall?trk=bf&trkInfo=bf&originalReferer=https://www.google.com&sessionRedirect=https%3A%2F%2Fde.linkedin.com%2Fin%2Fedal%25C3%25AD-c%25C3%25A1rdenas-beltr%25C3%25A1n-38670510a").domain)
        XCTAssertEqual("linkedin", Access.Remote(value: "www.linkedin.com/authwall?trk=bf&trkInfo=bf&originalReferer=https://www.google.com&sessionRedirect=https%3A%2F%2Fde.linkedin.com%2Fin%2Fedal%25C3%25AD-c%25C3%25A1rdenas-beltr%25C3%25A1n-38670510a").domain)
        XCTAssertEqual("hello", Access.Remote(value: "www.hello.com").domain)
        XCTAssertEqual("hello", Access.Remote(value: "www.hello.com/lol").domain)
        XCTAssertEqual("hello", Access.Remote(value: "www.hello.com:8080").domain)
        XCTAssertEqual("hello", Access.Remote(value: "www.hello.com:8080/lol").domain)
        XCTAssertEqual("world", Access.Remote(value: "www.hello.world.com/lol").domain)
        XCTAssertEqual("world", Access.Remote(value: "https://hello.world.com/lol").domain)
        XCTAssertEqual("bbc", Access.Remote(value: "https://bbc.co.uk").domain)
        XCTAssertEqual("privacy-inc", Access.Remote(value: "https://privacy-inc.github.io/about").domain)
    }
    
    func testSuffix() {
        XCTAssertEqual("", Access.Remote(value: "https://").suffix)
        XCTAssertEqual("", Access.Remote(value: "").suffix)
        XCTAssertEqual("", Access.Remote(value: "wds").suffix)
        XCTAssertEqual(".com", Access.Remote(value: "https://www.linkedin.com/authwall?trk=bf&trkInfo=bf&originalReferer=https://www.google.com&sessionRedirect=https%3A%2F%2Fde.linkedin.com%2Fin%2Fedal%25C3%25AD-c%25C3%25A1rdenas-beltr%25C3%25A1n-38670510a").suffix)
        XCTAssertEqual(".com", Access.Remote(value: "www.linkedin.com/authwall?trk=bf&trkInfo=bf&originalReferer=https://www.google.com&sessionRedirect=https%3A%2F%2Fde.linkedin.com%2Fin%2Fedal%25C3%25AD-c%25C3%25A1rdenas-beltr%25C3%25A1n-38670510a").suffix)
        XCTAssertEqual(".com", Access.Remote(value: "www.hello.com").suffix)
        XCTAssertEqual(".com", Access.Remote(value: "www.hello.com/lol").suffix)
        XCTAssertEqual(".com", Access.Remote(value: "www.hello.com:8080").suffix)
        XCTAssertEqual(".com", Access.Remote(value: "www.hello.com:8080/lol").suffix)
        XCTAssertEqual(".com", Access.Remote(value: "www.hello.world.com/lol").suffix)
        XCTAssertEqual(".com", Access.Remote(value: "https://hello.world.com/lol").suffix)
        XCTAssertEqual(".co.uk", Access.Remote(value: "https://bbc.co.uk").suffix)
        XCTAssertEqual(".app", Access.Remote(value: "https://goprivacy.app").suffix)
        XCTAssertEqual(".github.io", Access.Remote(value: "https://privacy-inc.github.io/about").suffix)
    }
    
    func testSecure() {
        XCTAssertTrue(Access.Remote(value: "https://www.aguacate.com").secure)
        XCTAssertFalse(Access.Remote(value: "http://www.aguacate.com").secure)
        XCTAssertFalse(Access.Remote(value: "ftp://www.aguacate.com").secure)
    }
}
