import XCTest
@testable import Specs

final class TrackersTests: XCTestCase {
    func testStorable() {
        let website = Website(id: "https://www.aguacate.com:8080/asd/124?page=32123&lsd=1", title: "").with(title: "adsdasafas")
        XCTAssertEqual(website.title, website.data.prototype(Website.self).title)
        XCTAssertEqual(website.id, website.data.prototype(Website.self).id)
    }
}
