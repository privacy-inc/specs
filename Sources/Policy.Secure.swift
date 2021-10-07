import Foundation
import Domains

extension Policy {
    struct Secure: PolicyLevel {
        let level = Policy.secure
        
        func route(url: URL) -> Result {
            url
                .host
                .map(Tld.domain(host:))
                .map { domain in
                    domain.suffix.isEmpty
                    ? .ignore
                    : URL
                        .Allow
                        .result(domain: domain, url: url)
                    ?? URL
                        .Deny
                        .result(domain: domain)
                    ?? URL
                        .Toplevel
                        .result(domain: domain)
                    ?? .allow
                }
            ?? .ignore
        }
    }
}
