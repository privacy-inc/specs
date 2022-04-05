import XCTest
@testable import Specs

final class URLTests: XCTestCase {
    func testFileName() {
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org")!.file("png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/")!.file("png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc")!.file("png"))
        XCTAssertEqual("abc.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc.html")!.file("png"))
        XCTAssertEqual("x.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc.x.html")!.file("png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc/")!.file("png"))
    }
    
    func testRemote() {
        XCTAssertNil(URL(string: "privacy://hello%20world")?.remote)
        XCTAssertNil(URL(string: "data:image/jpeg;base64")?.remote)
        XCTAssertNil(URL(string: "about:blank")?.remote)
        XCTAssertNil(URL(fileURLWithPath: NSTemporaryDirectory() + "file.html").remote)
        XCTAssertEqual("https://www.aguacate.com", URL(string: "https://www.aguacate.com")?.remote)
        XCTAssertEqual("https://goprivacy.app", URL(string: "https://goprivacy.app")?.remote)
    }
}
