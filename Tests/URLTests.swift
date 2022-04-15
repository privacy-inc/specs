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
    
    func testIcon() {
        XCTAssertEqual("www.avocado.www.ck%2Fhello", try? URL(string: "www.avocado.www.ck/hello")?.icon)
        XCTAssertEqual("hello.com%2Fa", try? URL(string: "https://hello.com/a")?.icon)
        XCTAssertEqual("hello.com", try? URL(string: "http://hello.com")?.icon)
        XCTAssertEqual("a.hello.com%2Fa", try? URL(string: "https://a.hello.com/a?var=3231123")?.icon)
        XCTAssertEqual("a.hello.com%2Fa", try? URL(string: "https://a.hello.com/a/b/c?var=3231123")?.icon)
        XCTAssertEqual("a.hello.com%2F", try? URL(string: "https://a.hello.com/?var=3231123")?.icon)
        XCTAssertEqual("twitter.com%2F_vaux", try? URL(string: "twitter.com/_vaux")?.icon)
        XCTAssertEqual("de.m.wikipedia.org%2Fwiki", try? URL(string: "https://de.m.wikipedia.org/wiki/Alan_Moore#/languages")?.icon)
    }
}
