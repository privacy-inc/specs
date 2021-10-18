import Foundation
@testable import Specs

struct BlockerParser {
    private let dictionary: [[String : [String : Any]]]
    
    init(content: String) {
        dictionary = (try! JSONSerialization.jsonObject(with: .init(content.utf8))) as! [[String : [String : Any]]]
    }
    
    var cookies: Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "block-cookies"
            && ($0["trigger"]!["url-filter"] as! String) == ".*"
        }
    }
    
    var http: Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "make-https"
            && ($0["trigger"]!["url-filter"] as! String) == ".*"
        }
    }
    
    var third: Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "block"
            && ($0["trigger"]!["url-filter"] as! String) == ".*"
            && ($0["trigger"]!["load-type"] as! [String]).first == "third-party"
            && ($0["trigger"]!["resource-type"] as! [String]).first == "script"
        }
    }
    
    func css(url: String, selectors: [String]) -> Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "css-display-none"
                && ($0["action"]!["selector"] as! String)
                .components(separatedBy: ", ")
                .intersection(other: selectors).count == selectors.count
                && ($0["trigger"]!["url-filter"] as! String).hasPrefix("^https?://+([^:/]+\\.)?")
                && ($0["trigger"]!["url-filter"] as! String).hasSuffix("[:/]")
                && ($0["trigger"]!["url-filter-is-case-sensitive"] as! Bool)
                && ($0["trigger"]!["load-type"] as! [String]).first == "first-party"
                && ($0["trigger"]!["resource-type"] as! [String]).first == "document"
                && ($0["trigger"]!["if-domain"] as! [String]).first == "*" + url
        }
    }
    
    func css(selectors: [String]) -> Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "css-display-none"
                && ($0["action"]!["selector"] as! String)
                .components(separatedBy: ", ")
                .intersection(other: selectors).count == selectors.count
                && ($0["trigger"]!["url-filter"] as! String) == ".*"
        }
    }
    
    func amount(url: String) -> Int {
        dictionary.filter {
            ($0["trigger"]?["if-domain"] as? [String])?.first == "*" + url
        }.count
    }
}
