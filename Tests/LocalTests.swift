import XCTest
@testable import Specs

final class LocalTests: XCTestCase {
    func testDomain() {
        XCTAssertEqual("image.png", Access.Local(value: "/private/var/mobile/Containers/Data/Application/74C82CFA-C973-4CDD-ADDF-8DC95C6E3B11/tmp/image.png", bookmark: .init()).file)
        XCTAssertEqual("index.html", Access.Local(value: "file:///Users/vaux/Downloads/about/index.html", bookmark: .init()).file)
    }
    
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
