import Foundation
import Domains

extension Access {
    public struct Remote: Hashable {
        public let domain: String
        public let suffix: String
        let value: String
        
        init(value: String) {
            self.value = value
            let base = value
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .components(separatedBy: "/")
                .first!
                .components(separatedBy: ":")
                .first!
            
            let tld = Tld.deconstruct(url: base)
            domain = tld.domain
            suffix = tld.suffix
        }
        
        public var url: URL? {
            .init(string: value)
        }
        
        public var secure: Bool {
            value
                .hasPrefix(URL
                                .Scheme
                                .https
                                .rawValue)
        }
        
        public func hash(into: inout Hasher) {
            into.combine(value)
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.value == rhs.value
        }
    }
}
