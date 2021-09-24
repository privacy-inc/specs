import XCTest
@testable import Specs

final class WebsiteTests: XCTestCase {
    func testStorable() {
        let website = Website(title: "adsdasafas", access: Access.Remote(value: "https://www.aguacate.com:8080/asd/124?page=32123&lsd=1"))
        XCTAssertEqual(website.title, website.data.prototype(Website.self).title)
        XCTAssertEqual(website.access.value, website.data.prototype(Website.self).access.value)
    }
}
