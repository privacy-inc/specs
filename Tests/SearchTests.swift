import XCTest
@testable import Specs

final class SearchTests: XCTestCase {
    private var search: Search!
    
    override func setUp() {
        search = .init(engine: .google)
    }
    
    func testStorable() {
        XCTAssertEqual(.google, Search(engine: .google).data.prototype(Search.self).engine)
        XCTAssertEqual(.ecosia, Search(engine: .ecosia).data.prototype(Search.self).engine)
    }
    
    func testEmpty() {
        XCTAssertNil(search(search: "") { $0 })
        XCTAssertNil(search(search: " ") { $0 })
        XCTAssertNil(search(search: "\n") { $0 })
    }
    
    func testSearch() {
        XCTAssertEqual("https://www.ecosia.org/search?q=hello%20world", Search(engine: .ecosia)(search: "hello world") { $0 })
        XCTAssertEqual("https://www.google.com/search?q=hello%20world", search(search: "hello world") { $0 })
    }
    
    func testURL() {
        XCTAssertEqual("https://github.com", search(search: "https://github.com") { $0 })
        XCTAssertEqual("https://hello.com/aguacate", search(search: "hello.com/aguacate") { $0 })
    }
    
    func testPartialURL() {
        XCTAssertEqual("https://github.com", search(search: "github.com") { $0 })
    }
    
    func testDeeplinks() {
        XCTAssertEqual("itms-services://?action=purchaseIntent&bundleId=incognit&productIdentifier=incognit.plus", search(search: "itms-services://?action=purchaseIntent&bundleId=incognit&productIdentifier=incognit.plus") { $0 })
    }
    
    func testAmpersand() {
        XCTAssertEqual("https://www.google.com/search?q=hello%26world", search(search: "hello&world") { $0 })
    }
    
    func testPlus() {
        XCTAssertEqual("https://www.google.com/search?q=hello+world", search(search: "hello+world") { $0 })
    }
    
    func testCaret() {
        XCTAssertEqual("https://www.google.com/search?q=hello%5Eworld", search(search: "hello^world") { $0 })
    }
    
    func testSemiColon() {
        XCTAssertEqual("https://www.google.com/search?q=hello:world", search(search: "hello:world") { $0 })
    }
    
    func testSemicolonWithURL() {
        XCTAssertEqual("https://www.google.com/search?q=wkwebview%20site:%20stackoverflow.com", search(search: "wkwebview site: stackoverflow.com") { $0 })
    }
    
    func testAlmostURLButSearch() {
        XCTAssertEqual("https://www.google.com/search?q=facebook.com%20cezz", search(search: "facebook.com cezz") { $0 })
    }
    
    func testURLWithSpace() {
        XCTAssertEqual("https://www.google.com/search?q=hello%20world", search(search: "https://www.google.com/search?q=hello world") { $0 })
    }
    
    func testLocalPath() {
        XCTAssertEqual("https://www.google.com/search?q=/private/var/mobile/Containers/Data/Application/74C82CFA-C973-4CDD-ADDF-8DC95C6E3B11/tmp/image.png", search(search: "/private/var/mobile/Containers/Data/Application/74C82CFA-C973-4CDD-ADDF-8DC95C6E3B11/tmp/image.png") { $0 })
        
        XCTAssertEqual("file:///Users/vaux/Downloads/about/index.html", search(search: "file:///Users/vaux/Downloads/about/index.html") { $0 })
        
    }
    
    func testHttp() {
        XCTAssertEqual("https://www.google.com/search?q=http", search(search: "http") { $0 })
        XCTAssertEqual("https://www.google.com/search?q=https", search(search: "https") { $0 })
        XCTAssertEqual("https://www.google.com/search?q=https:", search(search: "https:") { $0 })
        XCTAssertEqual("https://www.google.com/search?q=https:/", search(search: "https:/") { $0 })
        XCTAssertEqual("https://www.google.com/search?q=https://", search(search: "https://") { $0 })
    }
    
    func testDeeplink() {
        XCTAssertEqual("macappstores://apps.apple.com/us/app/avocado-kanban/id1549855022?app=mac-app&extRefUrl2=https%3A%2F%2Favoca-do.github.io", search(search: "macappstores://apps.apple.com/us/app/avocado-kanban/id1549855022?app=mac-app&extRefUrl2=https%3A%2F%2Favoca-do.github.io") { $0 })
    }
    
    func testNonEnglishCharacters() {
        XCTAssertEqual("https://something.com/a/%C3%B1", search(search: "https://something.com/a/ñ") { $0 })
    }
    
    func testUsingTld() {
        XCTAssertEqual("https://www.google.com/search?q=total.12", search(search: "total.12") { $0 })
    }
    
    func testIsFirstLevelTld() {
        XCTAssertEqual("https://www.google.com/search?q=total.0", search(search: "total.0") { $0 })
    }
}
