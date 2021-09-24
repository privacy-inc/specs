import Foundation
import Domains

extension Access {
    public struct Remote: AccessType {
        public let key = Access.remote
        public let value: String
        public let domain: String
        public let suffix: String
        
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
    }
}
