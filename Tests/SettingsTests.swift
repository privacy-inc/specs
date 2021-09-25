import XCTest
@testable import Specs

final class SettingsTests: XCTestCase {
    private var settings: Settings!
    
    override func setUp() {
        settings = .init()
    }
    
    func testSearch() {
        XCTAssertEqual(.google, settings.search.engine)
        settings.search = .init(engine: .ecosia)
        XCTAssertEqual(.ecosia, settings.data.prototype(Settings.self).search.engine)
    }
}
