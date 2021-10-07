import Foundation
import Domains

extension Access {
    public struct Remote: AccessURL {
        public var domain: String {
            value
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .components(separatedBy: "/")
                .first!
                .components(separatedBy: ":")
                .first
                .map(Tld.domain(host:))
                .map(\.minimal)
            ?? ""
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
