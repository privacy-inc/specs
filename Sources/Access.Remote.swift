import Foundation
import Domains

extension Access {
    public struct Remote: AccessURL {
        public let key = Access.remote
        public let value: String
        public let domain: String
        
        init(value: String) {
            self.value = value
            let base = value
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .components(separatedBy: "/")
                .first!
                .components(separatedBy: ":")
                .first!
            
            domain = {
                $0.domain + $0.suffix
            } (Tld.deconstruct(url: base))
        }
        
        public var url: URL? {
            .init(string: value)
        }
    }
}
