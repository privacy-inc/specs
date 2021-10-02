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
    
    func testPolicy() {
        XCTAssertEqual(.secure, settings.policy.level)
        settings.policy = Policy.Standard()
        XCTAssertEqual(.standard, settings.data.prototype(Settings.self).policy.level)
    }
}
