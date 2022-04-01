import Foundation
import Domains

extension String {
    public var domain: String {
        replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .components(separatedBy: "/")
            .first!
            .components(separatedBy: ":")
            .first
            .map(Tld.domain(host:))!
            .minimal
            .lowercased()
    }
    
    func rating(components: [String]) -> Int {
        components
            .filter(localizedCaseInsensitiveContains)
            .count
    }
}
