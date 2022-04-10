import XCTest
@testable import Specs

final class SettingsConfigurationTests: XCTestCase {
    private var configuration: Settings.Configuration!
    
    override func setUp() {
        configuration = .init()
    }
    
    func testAutoplay() {
        XCTAssertEqual(.none, configuration.autoplay)
        configuration.autoplay = .audio
        XCTAssertEqual(.audio, configuration.data.prototype(Settings.Configuration.self).autoplay)
    }
    
    func testJavascript() {
        XCTAssertTrue(configuration.javascript)
        configuration.javascript = false
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).javascript)
    }
    
    func testPopups() {
        XCTAssertFalse(configuration.popups)
        configuration.popups = true
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).popups)
    }
    
    func testLocation() {
        XCTAssertFalse(configuration.location)
        configuration.location = true
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).location)
    }
    
    func testTimers() {
        XCTAssertTrue(configuration.timers)
        XCTAssertFalse(configuration.scripts.contains(Script.timers))

        configuration.timers = false
        XCTAssertTrue(configuration.scripts.contains(Script.timers))
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).timers)
    }
    
    func testDark() {
        XCTAssertTrue(configuration.dark)
        XCTAssertTrue(configuration.blockList(dark: true).contains(.antidark))
        XCTAssertFalse(configuration.blockList(dark: false).contains(.antidark))
        
        configuration.dark = false
        XCTAssertFalse(configuration.blockList(dark: true).contains(.antidark))
        XCTAssertFalse(configuration.blockList(dark: false).contains(.antidark))
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).dark)
    }
    
    func testAds() {
        XCTAssertFalse(configuration.ads)
        XCTAssertTrue(configuration.blockList(dark: false).contains(.ads))
        
        configuration.ads = true
        XCTAssertFalse(configuration.blockList(dark: false).contains(.ads))
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).ads)
    }
    
    func testScreen() {
        XCTAssertFalse(configuration.screen)
        XCTAssertTrue(configuration.blockList(dark: false).contains(.screen))
        XCTAssertTrue(configuration.scripts.contains(Script.scroll))
        
        configuration.screen = true
        XCTAssertFalse(configuration.blockList(dark: false).contains(.screen))
        XCTAssertFalse(configuration.scripts.contains(Script.scroll))
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).screen)
    }
    
    func testCookies() {
        XCTAssertFalse(configuration.cookies)
        XCTAssertTrue(configuration.blockList(dark: false).contains(.cookies))
        
        configuration.cookies = true
        XCTAssertFalse(configuration.blockList(dark: false).contains(.cookies))
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).cookies)
    }
    
    func testHttp() {
        XCTAssertFalse(configuration.http)
        XCTAssertTrue(configuration.blockList(dark: false).contains(.http))
        
        configuration.http = true
        XCTAssertFalse(configuration.blockList(dark: false).contains(.http))
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).http)
    }
    
    func testThird() {
        XCTAssertTrue(configuration.third)
        XCTAssertFalse(configuration.blockList(dark: false).contains(.third))
        
        configuration.third = false
        XCTAssertTrue(configuration.blockList(dark: false).contains(.third))
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).third)
    }
    
    func testHistory() {
        XCTAssertTrue(configuration.history)
        configuration.history = false
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).history)
    }
    
    func testFavicons() {
        XCTAssertTrue(configuration.favicons)
        configuration.favicons = false
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).favicons)
    }
    
    func testBlockersInitial() {
        XCTAssertEqual(.init(Blocker
                                .allCases
                                .filter {
                                    $0 != .third
                        }), configuration.blockList(dark: true))
    }
}
