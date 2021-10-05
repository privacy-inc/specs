import XCTest
@testable import Specs

final class SettingsConfigurationTests: XCTestCase {
    private var configuration: Settings.Configuration!
    
    override func setUp() {
        configuration = .init()
    }
    
    func testAutoplay() {
        XCTAssertEqual(.none, configuration.autoplay)
        configuration = configuration
            .with(autoplay: .audio)
        XCTAssertEqual(.audio, configuration.data.prototype(Settings.Configuration.self).autoplay)
    }
    
    func testJavascript() {
        XCTAssertTrue(configuration.javascript)
        configuration = configuration
            .with(javascript: false)
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).javascript)
    }
    
    func testPopups() {
        XCTAssertFalse(configuration.popups)
        configuration = configuration
            .with(popups: true)
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).popups)
    }
    
    func testLocation() {
        XCTAssertFalse(configuration.location)
        configuration = configuration
            .with(location: true)
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).location)
    }
    
    func testTimers() {
        XCTAssertTrue(configuration.timers)
        configuration = configuration
            .with(timers: false)
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).timers)
    }
    
    func testDark() {
        XCTAssertTrue(configuration.dark)
        configuration = configuration
            .with(dark: false)
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).dark)
    }
    
    func testAds() {
        XCTAssertFalse(configuration.ads)
        configuration = configuration
            .with(ads: true)
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).ads)
    }
    
    func testScreen() {
        XCTAssertFalse(configuration.screen)
        configuration = configuration
            .with(screen: true)
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).screen)
    }
    
    func testCookies() {
        XCTAssertFalse(configuration.cookies)
        configuration = configuration
            .with(cookies: true)
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).cookies)
    }
    
    func testHttp() {
        XCTAssertFalse(configuration.http)
        configuration = configuration
            .with(http: true)
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).http)
    }
    
    func testThird() {
        XCTAssertTrue(configuration.third)
        configuration = configuration
            .with(third: false)
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).third)
    }
}
