import XCTest
@testable import Specs

final class SettingsTests: XCTestCase {
    private var settings: Settings!
    
    override func setUp() {
        settings = .init()
    }
    
    func testSearch() {
        XCTAssertEqual(.google, settings.search.engine)
        settings = settings
            .with(search: .init(engine: .ecosia))
        XCTAssertEqual(.ecosia, settings.data.prototype(Settings.self).search.engine)
    }
    
    func testPolicy() {
//        XCTAssertEqual(.secure, settings.policy.level)
//        settings = settings
//            .with(policy: Policy.Standard())
//        XCTAssertEqual(.standard, settings.data.prototype(Settings.self).policy.level)
    }
    
    func testConfiguration() {
        XCTAssertEqual(.none, settings.configuration.autoplay)
        settings = settings
            .with(configuration: settings
                    .configuration
                    .with(autoplay: .video))
        XCTAssertEqual(.video, settings.data.prototype(Settings.self).configuration.autoplay)
    }
}
