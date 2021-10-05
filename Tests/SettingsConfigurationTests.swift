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
        XCTAssertTrue(configuration._blockers.contains(.antidark))
        
        configuration = configuration
            .with(dark: false)
        XCTAssertFalse(configuration._blockers.contains(.antidark))
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
        
        configuration = configuration
            .with(screen: true)
        XCTAssertFalse(configuration._blockers.contains(.screen))
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
