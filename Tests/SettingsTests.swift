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
        XCTAssertEqual(.secure, settings.policy.level)
        settings = settings
            .with(policy: Policy.Standard())
        XCTAssertEqual(.standard, settings.data.prototype(Settings.self).policy.level)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    func testInitial() {
        XCTAssertTrue(Router.secure === settings.router)
        XCTAssertEqual(.init(Blocker
                                .allCases
                                .filter {
                                    $0 != .third
                                }), settings.blocking)
    }
    
    func testEngine() {
        settings.engine = .ecosia
        XCTAssertEqual(.ecosia, (settings.pre + settings.post).prototype(Settings.self).engine)
    }
    
    func testJavascript() {
        settings.javascript = false
        XCTAssertFalse((settings.pre + settings.post).prototype(Settings.self).javascript)
    }
    
    func testDark() {
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.antidark))
        settings.dark = false
        XCTAssertFalse(settings.blocking.contains(.antidark))
        XCTAssertFalse((settings.pre + settings.post).prototype(Settings.self).dark)
        XCTAssertFalse((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.antidark))
    }
    
    func testPopups() {
        settings.popups = true
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).popups)
    }
    
    func testAds() {
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.ads))
        settings.ads = true
        XCTAssertFalse(settings.blocking.contains(.ads))
        XCTAssertFalse((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.ads))
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).ads)
    }
    
    func testScreen() {
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.screen))
        settings.screen = true
        XCTAssertFalse(settings.blocking.contains(.screen))
        XCTAssertFalse((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.screen))
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).screen)
    }
    
    func testTrackers() {
        XCTAssertTrue(Router.secure === (settings.pre + settings.post).prototype(Settings.self).router)
        settings.trackers = true
        XCTAssertTrue(Router.regular === settings.router)
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).trackers)
        XCTAssertTrue(Router.regular === (settings.pre + settings.post).prototype(Settings.self).router)
    }
    
    func testCookies() {
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.cookies))
        settings.cookies = true
        XCTAssertFalse(settings.blocking.contains(.cookies))
        XCTAssertFalse((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.cookies))
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).cookies)
    }
    
    func testHttp() {
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.http))
        settings.http = true
        XCTAssertFalse(settings.blocking.contains(.http))
        XCTAssertFalse((settings.pre + settings.post).prototype(Settings.self).blocking.contains(.http))
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).http)
    }
    
    func testLocation() {
        settings.location = true
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).location)
    }
    
    func testRules() {
        settings.dark = false
        settings.ads = true
        settings.cookies = true
        settings.http = true
        settings.screen = true
        settings.third = true
        XCTAssertTrue(settings.blocking.isEmpty)
        
        settings.ads = false
        XCTAssertEqual([.ads], settings.blocking)
        
        settings.ads = true
        settings.cookies = false
        XCTAssertEqual([.cookies], settings.blocking)
        
        settings.cookies = true
        settings.http = false
        XCTAssertEqual([.http], settings.blocking)
        
        settings.http = true
        settings.screen = false
        XCTAssertEqual([.screen], settings.blocking)
        
        settings.screen = true
        settings.third = false
        XCTAssertEqual([.third], settings.blocking)
    }
    
    func testThird() {
        settings.engine = .ecosia
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).third)
        XCTAssertEqual(.ecosia, (settings.pre + settings.post).prototype(Settings.self).engine)
    }
    
    func testThirdCombined() {
        var archive = Archive.new
        archive.settings.engine = .ecosia
        archive.settings.third = false
        XCTAssertFalse(archive.data.prototype(Archive.self).settings.third)
        XCTAssertEqual(.ecosia, archive.data.prototype(Archive.self).settings.engine)
    }
    
    func testTimers() {
        settings.engine = .ecosia
        XCTAssertTrue((settings.pre + settings.post).prototype(Settings.self).timers)
        XCTAssertEqual(.ecosia, (settings.pre + settings.post).prototype(Settings.self).engine)
    }
    
    func testTimersCombined() {
        var archive = Archive.new
        archive.settings.engine = .ecosia
        archive.settings.timers = false
        XCTAssertFalse(archive.data.prototype(Archive.self).settings.timers)
        XCTAssertEqual(.ecosia, archive.data.prototype(Archive.self).settings.engine)
    }
    
    
    
    
    
    
    
    
    func testBegin() {
        XCTAssertEqual(Script.dark + Script.favicon, settings.start)
        settings.dark = false
        XCTAssertEqual(Script.favicon, settings.start)
    }
    
    func testEnd() {
        XCTAssertEqual(Script.scroll, settings.end)
        settings.location = true
        XCTAssertEqual(Script.scroll + Script.location, settings.end)
        settings.timers = false
        XCTAssertEqual(Script.scroll + Script.location + Script.timers, settings.end)
        settings.location = false
        XCTAssertEqual(Script.scroll + Script.timers, settings.end)
        settings.location = false
        settings.timers = true
        settings.screen = true
        XCTAssertTrue(settings.end.isEmpty)
    }
    */
}
