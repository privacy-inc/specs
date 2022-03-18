import XCTest
@testable import Specs

final class BlockerTests: XCTestCase {
    func testAllCases() {
        XCTAssertTrue(BlockerParser(content: Set(Blocker.allCases).rules)
                        .cookies)
        XCTAssertTrue(BlockerParser(content: Set(Blocker.allCases).rules)
                        .http)
        XCTAssertEqual(1, BlockerParser(content: Set(Blocker.allCases).rules)
                        .amount(url: "google.com"))
        XCTAssertTrue(BlockerParser(content: Set(Blocker.allCases).rules)
                        .css(url: "google.com", selectors: ["#taw",
                                                            "#consent-bump",
                                                            ".P1Ycoe"]))
    }
    
    func testCookies() {
        XCTAssertTrue(BlockerParser(content: Set([.cookies]).rules).cookies)
    }
    
    func testHttp() {
        XCTAssertTrue(BlockerParser(content: Set([.http]).rules).http)
    }
    
    func testThird() {
        XCTAssertTrue(BlockerParser(content: Set([Blocker.third]).rules).third)
    }
    
    func testAds() {
        XCTAssertTrue(BlockerParser(content: Set([.ads]).rules)
                        .css(url: "ecosia.org", selectors: [".card-ad",
                                                            ".card-productads"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.ads]).rules)
                        .css(url: "google.com", selectors: ["#taw",
                                                            "#rhs",
                                                            "#tadsb",
                                                            ".commercial",
                                                            ".Rn1jbe",
                                                            ".kxhcC",
                                                            ".isv-r.PNCib.BC7Tfc",
                                                            ".isv-r.PNCib.o05QGe"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.ads]).rules)
                        .css(url: "youtube.com", selectors: [".ytd-search-pyv-renderer",
                                                             ".video-ads.ytp-ad-module"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.ads]).rules)
                        .css(url: "bloomberg.com", selectors: [".leaderboard-wrapper"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.ads]).rules)
                        .css(url: "forbes.com", selectors: [".top-ad-container"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.ads]).rules)
                        .css(url: "huffpost.com", selectors: ["#advertisement-thamba"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.ads]).rules)
                        .css(url: "wordpress.com", selectors: [".inline-ad-slot"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.ads]).rules)
                        .css(selectors: ["[id*='google_ads']",
                                         "[id*='ezoic']",
                                         "[class*='ezoic']",
                                         "[id*='adngin']",
                                         ".adwrapper",
                                         ".ad-wrapper",
                                         "[class*='ad_placeholder']"]))
    }
    
    func testScreen() {
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "google.com", selectors: ["#consent-bump",
                                                            "#lb",
                                                            ".hww53CMqxtL__mobile-promo",
                                                            "#Sx9Kwc",
                                                            "#xe7COe",
                                                            ".NIoIEf",
                                                            ".QzsnAe.crIj3e",
                                                            ".ml-promotion-container",
                                                            ".USRMqe"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "ecosia.org", selectors: [".serp-cta-wrapper",
                                                            ".js-whitelist-notice",
                                                            ".callout-whitelist"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "youtube.com", selectors: ["#consent-bump",
                                                             ".opened",
                                                             ".ytd-popup-container",
                                                             ".upsell-dialog-lightbox",
                                                             ".consent-bump-lightbox",
                                                             "#lightbox",
                                                             ".ytd-consent-bump-v2-renderer"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "instagram.com", selectors: [".RnEpo.Yx5HN",
                                                               ".RnEpo._Yhr4",
                                                               ".R361B",
                                                               ".NXc7H.jLuN9.X6gVd",
                                                               ".f11OC"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "twitter.com", selectors: [
                                ".css-1dbjc4n.r-aqfbo4.r-1p0dtai.r-1d2f490.r-12vffkv.r-1xcajam.r-zchlnj"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "reuters.com", selectors: ["#onetrust-consent-sdk",
                                                             "#newReutersModal"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "thelocal.de", selectors: ["#qc-cmp2-container",
                                                             ".tp-modal",
                                                             ".tp-backdrop"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "pinterest.com", selectors: [
                                ".Jea.LCN.Lej.PKX._he.dxm.fev.fte.gjz.jzS.ojN.p6V.qJc.zI7.iyn.Hsu",
                                ".QLY.Rym.ZZS._he.ojN.p6V.zI7.iyn.Hsu"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "bbc.com", selectors: [".fc-consent-root",
                                                         "#cookiePrompt",
                                                         ".ssrcss-u3tmht-ConsentBanner.exhqgzu6"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "reddit.com", selectors: ["._3q-XSJ2vokDQrvdG6mR__k",
                                                            ".EUCookieNotice",
                                                            ".XPromoPopup"]))
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "medium.com", selectors: [".branch-journeys-top",
                                                            "#lo-highlight-meter-1-highlight-box",
                                                            "#branch-banner-iframe"]))
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "bloomberg.com", selectors: ["#fortress-paywall-container-root",
                                                               ".overlay-container",
                                                               "#fortress-preblocked-container-root"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "forbes.com", selectors: ["#consent_blackbar"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "huffpost.com", selectors: ["#qc-cmp2-container"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "nytimes.com", selectors: [".expanded-dock"]))
        
        XCTAssertTrue(BlockerParser(content: Set([.screen]).rules)
                        .css(url: "wordpress.com", selectors: ["#cmp-app-container"]))
    }
    
    func testAntidark() {
        XCTAssertTrue(BlockerParser(content: Set([.antidark]).rules)
                        .css(url: "google.com", selectors: [".P1Ycoe",
                                                            "#sDeBje"]))
    }
}
