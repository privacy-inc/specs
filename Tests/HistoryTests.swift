import XCTest
@testable import Specs

final class HistoryTests: XCTestCase {
    func testStorable() {
        let history = History(id: 99, website: .init(access: Access.with(url: URL(string: "https://avocado.org")!)))
        XCTAssertEqual("https://avocado.org", history.data.prototype(History.self).website.access.value)
        XCTAssertEqual(99, history.data.prototype(History.self).id)
    }
}
