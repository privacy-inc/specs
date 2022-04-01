import XCTest
@testable import Archivable
@testable import Specs

final class CloudSettingsTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testSearch() async {
        await cloud.update(search: .ecosia)
        let value = await cloud.model.settings.search
        XCTAssertEqual(.ecosia, value)
    }
    
    func testPolicy() async {
        await cloud.update(policy: .standard)
        let value = await cloud.model.settings.policy
        XCTAssertEqual(.standard, value)
    }
    
    func testAutoplay() async {
        await cloud.update(autoplay: .all)
        let value = await cloud.model.settings.configuration.autoplay
        XCTAssertEqual(.all, value)
    }
    
    func testJavascript() async {
        await cloud.update(javascript: false)
        let value = await cloud.model.settings.configuration.javascript
        XCTAssertFalse(value)
    }
    
    func testPopups() async {
        await cloud.update(popups: true)
        let value = await cloud.model.settings.configuration.popups
        XCTAssertTrue(value)
    }
    
    func testLocation() async {
        await cloud.update(location: true)
        let value = await cloud.model.settings.configuration.location
        XCTAssertTrue(value)
    }
    
    func testTimers() async {
        await cloud.update(timers: false)
        let value = await cloud.model.settings.configuration.timers
        XCTAssertFalse(value)
    }
    
    func testDark() async {
        await cloud.update(dark: false)
        let value = await cloud.model.settings.configuration.dark
        XCTAssertFalse(value)
    }
    
    func testAds() async {
        await cloud.update(ads: true)
        let value = await cloud.model.settings.configuration.ads
        XCTAssertTrue(value)
    }
    
    func testScreen() async {
        await cloud.update(screen: true)
        let value = await cloud.model.settings.configuration.screen
        XCTAssertTrue(value)
    }
    
    func testCookies() async {
        await cloud.update(cookies: true)
        let value = await cloud.model.settings.configuration.cookies
        XCTAssertTrue(value)
    }
    
    func testHttp() async {
        await cloud.update(http: true)
        let value = await cloud.model.settings.configuration.http
        XCTAssertTrue(value)
    }
    
    func testThird() async {
        await cloud.update(third: false)
        let value = await cloud.model.settings.configuration.third
        XCTAssertFalse(value)
    }
}
