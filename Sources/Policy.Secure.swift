import Foundation
import Domains

extension Policy {
    struct Secure: PolicyLevel {
        let level = Policy.secure
        
        func route(url: URL) -> Validation {
            url
                .host
                .map(Tld.domain(host:))
                .map { domain in
                    domain.suffix.isEmpty
                    ? .ignore
                    : URL
                        .Subdomain
                        .validation(domain: domain)
                    ?? URL
                        .Allow
                        .validation(domain: domain, url: url)
                    ?? URL
                        .Deny
                        .validation(domain: domain)
                    ?? URL
                        .Toplevel
                        .validation(domain: domain)
                    ?? .allow(domain: domain)
                }
            ?? .ignore
        }
    }
}
