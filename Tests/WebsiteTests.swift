import XCTest
@testable import Specs

final class WebsiteTests: XCTestCase {
    func testStorable() {
        let website = Website(id: "https://www.aguacate.com:8080/asd/124?page=32123&lsd=1", title: "").with(title: "adsdasafas")
        XCTAssertEqual(website.title, website.data.prototype(Website.self).title)
        XCTAssertEqual(website.id, website.data.prototype(Website.self).id)
    }
    
    func testStorableLongTitle() {
        let website = Website(id: "https://www.aguacate.com:8080/asd/124?page=32123&lsd=1", title: "")
            .with(title: "dasdsad af ad sad f sda asd sa dsa ds sa dsa dsa dsa d asd as das dsa dasdsad af ad sad f sda asd sa dsa ds sa dsa dsa dsa d asd as das dsa dasdsad af ad sad f sda asd sa dsa ds sa dsa dsa dsa d asd as das dsa dasdsad af ad sad f sda asd sa dsa ds sa dsa dsa dsa d asd as das dsa")
        XCTAssertEqual(website.title, website.data.prototype(Website.self).title)
    }
    
    func testEmptySearch() {
        var archive = Archive()
        archive.history = [.init(id: "https://aguacate.org", title: "hello world")]
        XCTAssertEqual(1, archive.websites(filter: "").count)
        XCTAssertEqual(1, archive.websites(filter: " ").count)
        XCTAssertEqual(1, archive.websites(filter: "\n ").count)
    }
    
    func testEmptySearchNoSort() {
        var archive = Archive()
        archive.history = [
            .init(id: "https://b.org", title: "b"),
            .init(id: "https://a.org", title: "a")]
        XCTAssertEqual(2, archive.websites(filter: "").count)
        XCTAssertEqual("b", archive.websites(filter: "").first?.title)
        XCTAssertEqual("a", archive.websites(filter: "").last?.title)
    }
    
    func testEmptyWebsites() {
        XCTAssertTrue(Archive().websites(filter: "hello world").isEmpty)
    }
    
    func testNoMatch() {
        var archive = Archive()
        archive.history = [
            .init(id: "https://b.org", title: "b"),
            .init(id: "https://a.org", title: "a")]
        XCTAssertTrue(archive.websites(filter: "rekall").isEmpty)
    }
    
    func testTitle() {
        var archive = Archive()
        archive.history = [
            .init(id: "https://b.org", title: "hello world"),
            .init(id: "https://a.org", title: "lorem ipsum")]
        XCTAssertEqual(1, archive.websites(filter: "lorem").count)
        XCTAssertEqual("lorem ipsum", archive.websites(filter: "lorem").first?.title)
    }
    
    func testURL() {
        var archive = Archive()
        archive.history = [
            .init(id: "https://b.org", title: "hello world"),
            .init(id: "https://a.org", title: "lorem ipsum")]
        XCTAssertEqual(1, archive.websites(filter: "b").count)
        XCTAssertEqual("hello world", archive.websites(filter: "b").first?.title)
    }
    
    func testSort() {
        var archive = Archive()
        archive.bookmarks = [
            .init(id: "https://im.org", title: ""),
            .init(id: "https://orem.org", title: ""),
            .init(id: "https://fdafsas.org", title: ""),
            .init(id: "https://ipsum.org", title: ""),
            .init(id: "https://im.org", title: ""),
            .init(id: "https://loremipsum.org/0", title: "ipsum lorem")]
        archive.history = [
            .init(id: "https://loremipsum.org/1", title: "ipsum lorem"),
            .init(id: "https://lorem.org", title: "ihello world"),
            .init(id: "https://aguacate.org", title: "lorem ipsum")]
        
        XCTAssertEqual(5, archive.websites(filter: "lorem ipsum").count)
        XCTAssertEqual("https://loremipsum.org/0", archive.websites(filter: "lorem ipsum")[0].id)
        XCTAssertEqual("https://loremipsum.org/1", archive.websites(filter: "lorem ipsum")[1].id)
        XCTAssertEqual("https://lorem.org", archive.websites(filter: "lorem ipsum")[4].id)
    }
    
    func testSortTitles() {
        var archive = Archive()
        archive.bookmarks = [.init(id: "https://aguacate.org", title: "world")]
        archive.history = [.init(id: "https://lorem.org", title: "hello")]
        
        XCTAssertEqual(2, archive.websites(filter: "hello world").count)
        XCTAssertEqual("hello", archive.websites(filter: "hello world").first?.title)
        XCTAssertEqual("world", archive.websites(filter: "hello world").last?.title)
    }
}
