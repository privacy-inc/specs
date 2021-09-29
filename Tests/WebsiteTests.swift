import XCTest
@testable import Specs

final class WebsiteTests: XCTestCase {
    func testStorable() {
        let website = Website(access: Access.with(url: URL(string: "https://www.aguacate.com:8080/asd/124?page=32123&lsd=1")!))
            .with(title: "adsdasafas")
        XCTAssertEqual(website.title, website.data.prototype(Website.self).title)
        XCTAssertEqual(website.access.value, website.data.prototype(Website.self).access.value)
    }
    
    func testStorableLongTitle() {
        let website = Website(access: Access.with(url: URL(string: "https://www.aguacate.com:8080/asd/124?page=32123&lsd=1")!))
            .with(title: "dasdsad af ad sad f sda asd sa dsa ds sa dsa dsa dsa d asd as das dsa dasdsad af ad sad f sda asd sa dsa ds sa dsa dsa dsa d asd as das dsa dasdsad af ad sad f sda asd sa dsa ds sa dsa dsa dsa d asd as das dsa dasdsad af ad sad f sda asd sa dsa ds sa dsa dsa dsa d asd as das dsa")
        XCTAssertEqual(website.title, website.data.prototype(Website.self).title)
    }
}
