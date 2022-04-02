import Foundation
import Domains

extension Access {
    struct Remote: AccessType {
        var domain: Domain {
            value
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .components(separatedBy: "/")
                .first!
                .components(separatedBy: ":")
                .first
                .map(Tld.domain(host:))!
        }
        
        let key = Access.remote
        let value: String
        
        var url: URL? {
            .init(string: value)
        }
        
        var content: Data {
            .init()
            .adding(size: UInt16.self, string: value)
        }
        
        init(value: String) {
            self.value = value
        }
    }
}
