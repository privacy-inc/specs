import XCTest
@testable import Specs

final class SettingsTests: XCTestCase {
    private var settings: Settings!
    
    override func setUp() {
        settings = .init()
    }
    
    func testSearch() {
        XCTAssertEqual(.google, settings.search)
        settings.search = .ecosia
        XCTAssertEqual(.ecosia, settings.data.prototype(Settings.self).search)
    }
    
    func testPolicy() {
        XCTAssertEqual(.secure, settings.policy)
        settings.policy = .standard
        XCTAssertEqual(.standard, settings.data.prototype(Settings.self).policy)
    }
    
    func testConfiguration() {
        XCTAssertEqual(.none, settings.configuration.autoplay)
        settings.configuration.autoplay = .video
        XCTAssertEqual(.video, settings.data.prototype(Settings.self).configuration.autoplay)
    }
}
