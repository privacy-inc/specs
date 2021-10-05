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
        XCTAssertFalse(configuration.scripts.end.contains(Script.timers))
        
        configuration = configuration
            .with(timers: false)
        XCTAssertTrue(configuration.scripts.end.contains(Script.timers))
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).timers)
    }
    
    func testDark() {
        XCTAssertTrue(configuration.dark)
        XCTAssertTrue(configuration._blockers.contains(.antidark))
        XCTAssertTrue(configuration.scripts.start.contains(Script.dark))
        
        configuration = configuration
            .with(dark: false)
        XCTAssertFalse(configuration._blockers.contains(.antidark))
        XCTAssertFalse(configuration.scripts.start.contains(Script.dark))
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).dark)
    }
    
    func testAds() {
        XCTAssertFalse(configuration.ads)
        XCTAssertTrue(configuration._blockers.contains(.ads))
        
        configuration = configuration
            .with(ads: true)
        XCTAssertFalse(configuration._blockers.contains(.ads))
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).ads)
    }
    
    func testScreen() {
        XCTAssertFalse(configuration.screen)
        XCTAssertTrue(configuration._blockers.contains(.screen))
        XCTAssertTrue(configuration.scripts.end.contains(Script.scroll))
        
        configuration = configuration
            .with(screen: true)
        XCTAssertFalse(configuration._blockers.contains(.screen))
        XCTAssertFalse(configuration.scripts.end.contains(Script.scroll))
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).screen)
    }
    
    func testCookies() {
        XCTAssertFalse(configuration.cookies)
        XCTAssertTrue(configuration._blockers.contains(.cookies))
        
        configuration = configuration
            .with(cookies: true)
        XCTAssertFalse(configuration._blockers.contains(.cookies))
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).cookies)
    }
    
    func testHttp() {
        XCTAssertFalse(configuration.http)
        XCTAssertTrue(configuration._blockers.contains(.http))
        
        configuration = configuration
            .with(http: true)
        XCTAssertFalse(configuration._blockers.contains(.http))
        XCTAssertTrue(configuration.data.prototype(Settings.Configuration.self).http)
    }
    
    func testThird() {
        XCTAssertTrue(configuration.third)
        XCTAssertFalse(configuration._blockers.contains(.third))
        
        configuration = configuration
            .with(third: false)
        XCTAssertTrue(configuration._blockers.contains(.third))
        XCTAssertFalse(configuration.data.prototype(Settings.Configuration.self).third)
    }
    
    func testBlockersInitial() {
        XCTAssertEqual(.init(Blocker
                                .allCases
                                .filter {
                                    $0 != .third
                                }), configuration._blockers)
    }
}
