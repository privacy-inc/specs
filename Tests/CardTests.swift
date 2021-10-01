import XCTest
@testable import Specs

final class CardTests: XCTestCase {
    func testStorable() {
        let card = Card(id: .bookmarks)
            .with(state: false)
        XCTAssertEqual(.bookmarks, card.data.prototype(Card.self).id)
        XCTAssertFalse(card.data.prototype(Card.self).state)
    }
}
