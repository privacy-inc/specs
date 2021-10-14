import Foundation
import Domains

extension Access {
    public struct Remote: AccessType {
        public var domain: Domain {
            value
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .components(separatedBy: "/")
                .first!
                .components(separatedBy: ":")
                .first
                .map(Tld.domain(host:))!
        }
        
        public let key = Access.remote
        public let value: String
        
        public var url: URL? {
            .init(string: value)
        }
        
        public var content: Data {
            .init()
            .adding(size: UInt16.self, string: value)
        }
        
        init(value: String) {
            self.value = value
        }
    }
}
