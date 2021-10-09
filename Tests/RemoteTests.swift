import XCTest
@testable import Specs

final class RemoteTests: XCTestCase {
    func testDomain() {
        XCTAssertEqual("", Access.Remote(value: "https://").domain.minimal)
        XCTAssertEqual("", Access.Remote(value: "").domain.minimal)
        XCTAssertEqual("wds", Access.Remote(value: "wds").domain.minimal)
        XCTAssertEqual("linkedin.com", Access.Remote(value: "https://www.linkedin.com/authwall?trk=bf&trkInfo=bf&originalReferer=https://www.google.com&sessionRedirect=https%3A%2F%2Fde.linkedin.com%2Fin%2Fedal%25C3%25AD-c%25C3%25A1rdenas-beltr%25C3%25A1n-38670510a").domain.minimal)
        XCTAssertEqual("linkedin.com", Access.Remote(value: "www.linkedin.com/authwall?trk=bf&trkInfo=bf&originalReferer=https://www.google.com&sessionRedirect=https%3A%2F%2Fde.linkedin.com%2Fin%2Fedal%25C3%25AD-c%25C3%25A1rdenas-beltr%25C3%25A1n-38670510a").domain.minimal)
        XCTAssertEqual("hello.com", Access.Remote(value: "www.hello.com").domain.minimal)
        XCTAssertEqual("hello.com", Access.Remote(value: "www.hello.com/lol").domain.minimal)
        XCTAssertEqual("hello.com", Access.Remote(value: "www.hello.com:8080").domain.minimal)
        XCTAssertEqual("hello.com", Access.Remote(value: "www.hello.com:8080/lol").domain.minimal)
        XCTAssertEqual("world.com", Access.Remote(value: "www.hello.world.com/lol").domain.minimal)
        XCTAssertEqual("world.com", Access.Remote(value: "https://hello.world.com/lol").domain.minimal)
        XCTAssertEqual("bbc.co.uk", Access.Remote(value: "https://bbc.co.uk").domain.minimal)
        XCTAssertEqual("privacy-inc.github.io", Access.Remote(value: "https://privacy-inc.github.io/about").domain.minimal)
    }
}
