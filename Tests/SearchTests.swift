import XCTest
@testable import Specs

final class SearchTests: XCTestCase {
    private var search: Search!
    
    override func setUp() {
        search = .google
    }
    
    func testEmpty() {
        XCTAssertNil(search(""))
        XCTAssertNil(search(" "))
        XCTAssertNil(search("\n"))
    }
    
    func testSearch() {
        XCTAssertEqual("https://www.ecosia.org/search?q=hello%20world", Search.ecosia("hello world"))
        XCTAssertEqual("https://www.google.com/search?q=hello%20world", search("hello world"))
        XCTAssertEqual("https://www.google.com/search?q=Hello%20World", search("Hello World"))
    }
    
    func testURL() {
        XCTAssertEqual("https://github.com", search("https://github.com"))
        XCTAssertEqual("https://hello.com/aguacate", search("hello.com/aguacate"))
        XCTAssertEqual("https://hello.com/Aguacate", search("hello.com/Aguacate"))
        XCTAssertEqual("https://www.Github.Com", search("www.Github.Com"))
        XCTAssertEqual("https://www.github.com", search("https://www.Github.com"))
        XCTAssertEqual("https://www.github.com", search("https://www.Github.Com"))
        XCTAssertEqual("https://www.google.com/search?q=Hello%20World", search("https://www.google.com/search?q=Hello%20World"))
        XCTAssertEqual("https://andymatuschak.org/files/papers/Apple%20Human%20Interface%20Guidelines%201987.pdf", search("andymatuschak.org/files/papers/Apple%20Human%20Interface%20Guidelines%201987.pdf"))
    }
    
    func testPartialURL() {
        XCTAssertEqual("https://github.com", search("github.com"))
        XCTAssertEqual("https://Github.com", search("Github.com"))
        XCTAssertEqual("https://Github.Com", search("Github.Com"))
    }
    
    func testDeeplinks() {
        XCTAssertEqual("itms-services://?action=purchaseIntent&bundleId=incognit&productIdentifier=incognit.plus", search("itms-services://?action=purchaseIntent&bundleId=incognit&productIdentifier=incognit.plus"))
    }
    
    func testAmpersand() {
        XCTAssertEqual("https://www.google.com/search?q=hello%26world", search("hello&world"))
    }
    
    func testPlus() {
        XCTAssertEqual("https://www.google.com/search?q=hello+world", search("hello+world"))
    }
    
    func testCaret() {
        XCTAssertEqual("https://www.google.com/search?q=hello%5Eworld", search("hello^world"))
    }
    
    func testSemiColon() {
        XCTAssertEqual("https://www.google.com/search?q=hello:world", search("hello:world"))
    }
    
    func testSemicolonWithURL() {
        XCTAssertEqual("https://www.google.com/search?q=wkwebview%20site:%20stackoverflow.com", search("wkwebview site: stackoverflow.com"))
    }
    
    func testAlmostURLButSearch() {
        XCTAssertEqual("https://www.google.com/search?q=facebook.com%20cezz", search("facebook.com cezz"))
    }
    
    func testURLWithSpace() {
        XCTAssertEqual("https://www.google.com/search?q=hello%20world", search("https://www.google.com/search?q=hello world"))
    }
    
    func testLocalPath() {
        XCTAssertEqual("https://www.google.com/search?q=/private/var/mobile/Containers/Data/Application/74C82CFA-C973-4CDD-ADDF-8DC95C6E3B11/tmp/image.png", search("/private/var/mobile/Containers/Data/Application/74C82CFA-C973-4CDD-ADDF-8DC95C6E3B11/tmp/image.png"))
        
        XCTAssertEqual("file:///Users/vaux/Downloads/about/index.html", search("file:///Users/vaux/Downloads/about/index.html"))
    }
    
    func testHttp() {
        XCTAssertEqual("https://www.google.com/search?q=http", search("http"))
        XCTAssertEqual("https://www.google.com/search?q=https", search("https"))
        XCTAssertEqual("https://www.google.com/search?q=https:", search("https:"))
        XCTAssertEqual("https://www.google.com/search?q=https:/", search("https:/"))
        XCTAssertEqual("https://www.google.com/search?q=https://", search("https://"))
    }
    
    func testDeeplink() {
        XCTAssertEqual("macappstores://apps.apple.com/us/app/avocado-kanban/id1549855022?app=mac-app&extRefUrl2=https%3A%2F%2Favoca-do.github.io", search("macappstores://apps.apple.com/us/app/avocado-kanban/id1549855022?app=mac-app&extRefUrl2=https%3A%2F%2Favoca-do.github.io"))
    }
    
    func testNonEnglishCharacters() {
        XCTAssertEqual("https://something.com/a/%C3%B1", search("https://something.com/a/ñ"))
    }
    
    func testUsingTld() {
        XCTAssertEqual("https://www.google.com/search?q=total.12", search("total.12"))
    }
    
    func testIsFirstLevelTld() {
        XCTAssertEqual("https://www.google.com/search?q=total.0", search("total.0"))
    }
    
    func testIsData() {
        XCTAssertEqual("data:text/html;charset=utf-8;base64,PGltZyBzcmM9Imh0dHBzOi8vc25hbW1hci1qdW1udGFsLmNvbS9mYXZpY29uLmljbyI+",
                       search("data:text/html;charset=utf-8;base64,PGltZyBzcmM9Imh0dHBzOi8vc25hbW1hci1qdW1udGFsLmNvbS9mYXZpY29uLmljbyI+"))
    }
}
