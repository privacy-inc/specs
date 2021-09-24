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
}
