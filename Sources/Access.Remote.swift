import Foundation
import Domains

extension Access {
    public struct Remote: AccessURL {
        public var domain: String {
            {
                $0.domain + $0.suffix
            } (Tld.deconstruct(url: value
                                .replacingOccurrences(of: "https://", with: "")
                                .replacingOccurrences(of: "http://", with: "")
                                .components(separatedBy: "/")
                                .first!
                                .components(separatedBy: ":")
                                .first!))
        }
        
        public let key = Access.remote
        public let value: String
        
        init(value: String) {
            self.value = value
        }
        
        public var url: URL? {
            .init(string: value)
        }
    }
}
